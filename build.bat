@echo off
setlocal EnableExtensions

rem ===========================================================================
rem  T Code - local release builder
rem
rem  Runs the same packaging scripts the removed GitHub Actions workflow used
rem  and collects every artifact in .\releases\[os]-[arch]\.
rem
rem  Usage:
rem    build.bat              Build Windows x86_64
rem    build.bat windows      Build Windows x86_64
rem    build.bat linux        Build Linux x86_64 through WSL
rem    build.bat darwin       Print the macOS build instructions
rem    build.bat all          Build every target this host supports
rem    build.bat setup        Install MSYS2 toolchain + Inno Setup
rem    build.bat doctor       Check the local toolchain
rem    build.bat clean        Delete build dirs and release artifacts
rem    build.bat help         Show this help
rem
rem  Environment:
rem    TCODE_VERSION=2.1.7        Version override for the artifact names
rem    TCODE_PRODUCTION=0         Dev build instead of a production build
rem    TCODE_ADDONS=welcome       Bundle plugins through lpm
rem    TCODE_BASH=C:\...\bash.exe Use a specific bash.exe
rem
rem  Output:
rem    releases\windows-x86_64\   portable zip + setup.exe + SHA256SUMS
rem    releases\linux-x86_64\     tar.gz + deb + AppImage, when built in WSL
rem    releases\darwin-[arch]\    tar.gz + dmg, when built on macOS
rem ===========================================================================

cd /d "%~dp0"

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "APP=%ROOT%\application"
set "RELEASES=%ROOT%\releases"
set "TCODE_ROOT=%ROOT%"

set "PRODFLAG=--production"
if defined TCODE_PRODUCTION if "%TCODE_PRODUCTION%"=="0" set "PRODFLAG="

set "ADDONSFLAG="
if defined TCODE_ADDONS set "ADDONSFLAG=-A %TCODE_ADDONS%"

set "TARGET=%~1"
if not defined TARGET set "TARGET=windows"

if /i "%TARGET%"=="help"   goto :help
if /i "%TARGET%"=="-h"     goto :help
if /i "%TARGET%"=="--help" goto :help
if /i "%TARGET%"=="windows" goto :target_windows
if /i "%TARGET%"=="win"     goto :target_windows
if /i "%TARGET%"=="all"     goto :target_all
if /i "%TARGET%"=="linux"   goto :target_linux
if /i "%TARGET%"=="wsl"     goto :target_linux
if /i "%TARGET%"=="darwin"  goto :target_darwin
if /i "%TARGET%"=="macos"   goto :target_darwin
if /i "%TARGET%"=="mac"     goto :target_darwin
if /i "%TARGET%"=="setup"   goto :do_setup
if /i "%TARGET%"=="doctor"  goto :do_doctor
if /i "%TARGET%"=="clean"   goto :do_clean

echo [build] Unknown target: "%TARGET%"
echo.
call :print_help
exit /b 1

rem ===========================================================================
rem  Targets
rem ===========================================================================

:help
call :print_help
exit /b 0

:target_windows
call :build_windows
if errorlevel 1 exit /b 1
goto :finish

:target_linux
call :wsl_available
if errorlevel 1 goto :no_wsl
call :build_linux
if errorlevel 1 exit /b 1
goto :finish

:no_wsl
call :report_linux_unavailable
exit /b 1

:target_darwin
call :report_darwin
exit /b 0

:target_all
set "FAILED=0"
call :build_windows
if errorlevel 1 set "FAILED=1"
call :wsl_available
if errorlevel 1 goto :all_skip_linux
call :build_linux
if errorlevel 1 set "FAILED=1"
goto :all_darwin
:all_skip_linux
echo.
echo [linux] skipped - WSL is not available on this host.
:all_darwin
call :report_darwin
goto :finish

:finish
echo.
echo [build] Artifacts root: %RELEASES%
if not exist "%RELEASES%" goto :finish_end
dir /b "%RELEASES%"
:finish_end
echo [build] Done.
if "%FAILED%"=="1" exit /b 1
exit /b 0

rem ===========================================================================
rem  Windows
rem ===========================================================================

:build_windows
call :locate_bash
if not defined BASH goto :windows_no_bash

"%BASH%" -lc "command -v meson ninja gcc cmake pkg-config >/dev/null 2>&1"
if errorlevel 1 goto :windows_no_tools

echo.
echo ============================================================
echo  Windows x86_64 release build
echo  bash: %BASH%
echo  out : %RELEASES%\windows-x86_64
echo ============================================================
echo.
call :check_innosetup

set "TCODE_DIST=%RELEASES%\windows-x86_64"
if exist "%TCODE_DIST%" rmdir /s /q "%TCODE_DIST%"

"%BASH%" -lc "cd \"$(cygpath -u \"$TCODE_ROOT\")\" && exec bash application/scripts/package.sh %PRODFLAG% %ADDONSFLAG% --distdir \"$(cygpath -u \"$TCODE_DIST\")\""
if errorlevel 1 goto :windows_failed

echo.
echo [windows] Artifacts:
dir /b "%TCODE_DIST%"
echo.
echo [windows] Done: %TCODE_DIST%
exit /b 0

:windows_no_bash
echo [windows] ERROR: no usable bash found.
echo           Install MSYS2 from https://www.msys2.org/ and run: build.bat setup
exit /b 1

:windows_no_tools
echo [windows] ERROR: meson/ninja/gcc/cmake/pkg-config missing from:
echo           %BASH%
echo           Run: build.bat setup
exit /b 1

:windows_failed
echo [windows] BUILD FAILED
exit /b 1

rem ===========================================================================
rem  Linux through WSL
rem ===========================================================================

:wsl_available
where wsl.exe >nul 2>&1
if errorlevel 1 exit /b 1
wsl.exe -e true >nul 2>&1
if errorlevel 1 exit /b 1
exit /b 0

:report_linux_unavailable
echo [linux] WSL2 with a Linux distribution is not available on this machine.
echo         Install it from an elevated prompt:
echo           wsl --install -d Ubuntu
echo         then rerun: build.bat linux
exit /b 0

:build_linux
set "TCODE_DIST=%RELEASES%\linux-x86_64"
if exist "%TCODE_DIST%" rmdir /s /q "%TCODE_DIST%"

echo.
echo ============================================================
echo  Linux x86_64 release build via WSL
echo  out: %TCODE_DIST%
echo ============================================================
echo.

wsl.exe -e bash -lc "command -v meson ninja gcc cmake pkg-config >/dev/null 2>&1"
if errorlevel 1 goto :linux_no_tools

wsl.exe -e bash -lc "cd \"$(wslpath -u '%ROOT%')\" && exec bash application/scripts/package.sh %PRODFLAG% %ADDONSFLAG% --distdir \"$(wslpath -u '%TCODE_DIST%')\""
if errorlevel 1 goto :linux_failed

rem AppImage is separate from package.sh. A failure here is not fatal:
rem the tar.gz and .deb are already in place.
wsl.exe -e bash -lc "cd \"$(wslpath -u '%ROOT%')\" && bash application/scripts/package-appimage.sh --nobuild --builddir application/build --distdir \"$(wslpath -u '%TCODE_DIST%')\""
if errorlevel 1 echo [linux] WARNING: AppImage step failed - other artifacts are still available.

rem package.sh wrote SHA256SUMS before the AppImage existed; refresh it.
wsl.exe -e bash -lc "cd \"$(wslpath -u '%TCODE_DIST%')\" && sha256sum tcode-* > SHA256SUMS"

echo.
echo [linux] Artifacts:
dir /b "%TCODE_DIST%"
echo.
echo [linux] Done: %TCODE_DIST%
exit /b 0

:linux_no_tools
echo [linux] ERROR: build tools missing inside WSL.
echo         Inside WSL run:
echo           sudo apt update
echo           sudo apt install -y meson ninja-build gcc pkg-config cmake ^
echo             libx11-dev libxext-dev libxrandr-dev libxrender-dev ^
echo             libxfixes-dev libxi-dev libxtst-dev libxss-dev ^
echo             libxkbcommon-dev libwayland-dev wayland-protocols ^
echo             libdecor-0-dev libgl1-mesa-dev libegl1-mesa-dev ^
echo             libdbus-1-dev libibus-1.0-dev ^
echo             dpkg-dev wget zip curl tar
exit /b 1

:linux_failed
echo [linux] BUILD FAILED
exit /b 1

rem ===========================================================================
rem  macOS
rem ===========================================================================

:report_darwin
echo.
echo [darwin] macOS cannot be built from a Windows host.
echo          On a Mac with the Xcode command line tools:
echo            xcode-select --install
echo            brew install meson ninja cmake pkg-config
echo            cd [repo root]
echo            bash application/scripts/package.sh --production --distdir releases/darwin-$(uname -m)
echo.
echo          Optional: pipx install dmgbuild     - adds the .dmg
echo          For a universal binary, build on an Intel and an Apple
echo          Silicon Mac, then combine the two binaries with lipo.
exit /b 0

rem ===========================================================================
rem  Setup / doctor / clean
rem ===========================================================================

:do_setup
call :locate_bash
if defined MSYS2_ROOT goto :setup_have_msys2
echo [setup] MSYS2 was not found.
echo         Install it from https://www.msys2.org/ into C:\msys64,
echo         then run: build.bat setup
exit /b 1

:setup_have_msys2
echo [setup] Installing MSYS2 UCRT64 build tools...
echo.
"%MSYS2_ROOT%\usr\bin\bash.exe" -lc "pacman -S --needed --noconfirm --disable-download-timeout mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-meson mingw-w64-ucrt-x86_64-ninja mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-pkg-config curl tar zip unzip"
if errorlevel 1 goto :setup_pacman_failed

echo.
call :install_innosetup
echo [setup] Done. Run: build.bat doctor
exit /b 0

:setup_pacman_failed
echo [setup] pacman failed. Open an MSYS2 UCRT64 shell and run:
echo         pacman -S --needed mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-meson mingw-w64-ucrt-x86_64-ninja mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-pkg-config curl tar zip unzip
exit /b 1

:install_innosetup
where winget.exe >nul 2>&1
if errorlevel 1 goto :innosetup_manual
echo [setup] Installing Inno Setup via winget...
winget install --id JRSoftware.InnoSetup -e --accept-source-agreements --accept-package-agreements
exit /b 0
:innosetup_manual
echo [setup] winget not found. Install Inno Setup manually from:
echo         https://jrsoftware.org/isdl.php
exit /b 0

:do_doctor
call :locate_bash
echo.
echo  T Code build environment
echo  ------------------------
echo  repo      : %ROOT%
echo  releases  : %RELEASES%
if not defined MSYS2_ROOT goto :doctor_no_msys2
echo  msys2     : %MSYS2_ROOT%
:doctor_no_msys2
if not defined BASH goto :doctor_no_bash
echo  bash      : %BASH%
"%BASH%" -lc "cd \"$(cygpath -u \"$TCODE_ROOT\")\" && pwd"
if errorlevel 1 echo  bash cwd  : FAILED
echo  tools     :
"%BASH%" -lc "for t in meson ninja gcc cmake pkg-config zip tar; do command -v $t >/dev/null 2>&1 && printf '    %%s OK\n' $t || printf '    %%s MISSING\n' $t; done"
goto :doctor_iscc
:doctor_no_bash
echo  bash      : NOT FOUND
echo  tools     : cannot check without bash
:doctor_iscc
call :check_innosetup
where wsl.exe >nul 2>&1
if errorlevel 1 goto :doctor_no_wsl
wsl.exe -e true >nul 2>&1
if errorlevel 1 goto :doctor_wsl_nodistro
echo  wsl       : ready
goto :doctor_end
:doctor_wsl_nodistro
echo  wsl       : installed, no distro
goto :doctor_end
:doctor_no_wsl
echo  wsl       : not installed
:doctor_end
exit /b 0

:do_clean
echo [clean] Removing build directories...
for /d %%D in ("%APP%\build*") do rmdir /s /q "%%D" 2>nul
if exist "%APP%\dist" rmdir /s /q "%APP%\dist"
if not exist "%RELEASES%" goto :clean_done
rem Keep docs such as RELEASE.md; remove only platform folders and stray artifacts.
for /d %%D in ("%RELEASES%\*") do rmdir /s /q "%%D" 2>nul
del /q "%RELEASES%\manifest.json" "%RELEASES%\SHA256SUMS" 2>nul
:clean_done
echo [clean] Done.
exit /b 0

rem ===========================================================================
rem  Helpers
rem ===========================================================================

:locate_bash
set "BASH="
set "MSYS2_ROOT="
if defined TCODE_BASH if exist "%TCODE_BASH%" set "BASH=%TCODE_BASH%"
if not defined MSYS2_ROOT if exist "C:\msys64\usr\bin\bash.exe" set "MSYS2_ROOT=C:\msys64"
if not defined MSYS2_ROOT if exist "%LOCALAPPDATA%\msys64\usr\bin\bash.exe" set "MSYS2_ROOT=%LOCALAPPDATA%\msys64"
if not defined MSYS2_ROOT if exist "C:\tools\msys64\usr\bin\bash.exe" set "MSYS2_ROOT=C:\tools\msys64"
if not defined BASH if defined MSYS2_ROOT set "BASH=%MSYS2_ROOT%\usr\bin\bash.exe"
if not defined BASH if exist "C:\Program Files\Git\bin\bash.exe" set "BASH=C:\Program Files\Git\bin\bash.exe"
if not defined BASH for /f "delims=" %%I in ('where bash 2^>nul') do if not defined BASH set "BASH=%%I"
if defined MSYS2_ROOT set "MSYSTEM=UCRT64"
exit /b 0

:check_innosetup
set "ISCC="
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" set "ISCC=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if not defined ISCC if exist "C:\Program Files\Inno Setup 6\ISCC.exe" set "ISCC=C:\Program Files\Inno Setup 6\ISCC.exe"
if not defined ISCC if exist "%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe" set "ISCC=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe"
if not defined ISCC for /f "delims=" %%I in ('where iscc 2^>nul') do if not defined ISCC set "ISCC=%%I"
if defined ISCC goto :iscc_found
echo [windows] NOTE: Inno Setup not found - setup.exe will be skipped.
echo           Run: build.bat setup
exit /b 0
:iscc_found
echo [windows] Inno Setup: %ISCC%
exit /b 0

:print_help
echo.
echo  T Code local release builder
echo.
echo  Usage:
echo    build.bat              Build Windows x86_64
echo    build.bat windows      Build Windows x86_64
echo    build.bat linux        Build Linux x86_64 through WSL
echo    build.bat darwin       Print the macOS build instructions
echo    build.bat all          Build every target this host supports
echo    build.bat setup        Install MSYS2 toolchain + Inno Setup
echo    build.bat doctor       Check the local toolchain
echo    build.bat clean        Delete build dirs and release artifacts
echo    build.bat help         Show this help
echo.
echo  Environment:
echo    TCODE_VERSION         Version override for the artifact names
echo    TCODE_PRODUCTION=0    Dev build instead of a production build
echo    TCODE_ADDONS          Comma separated plugins to bundle through lpm
echo    TCODE_BASH            Use a specific bash.exe
echo.
echo  Output: %RELEASES%
echo.
exit /b 0
