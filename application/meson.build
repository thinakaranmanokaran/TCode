#===============================================================================
# Layouts
#===============================================================================
# portable=true  -> prod portable: flat relocatable (exe + data/ + doc/)
# portable=false -> prod installable: FHS on Linux (bin/share), .app bundle
#                   on macOS, InnoSetup payload on Windows (flat, but
#                   installed via installer + shortcuts/PATH).
# See application/scripts/package.sh, package-portable.sh, package-installable.sh.
# Version including git commit (dev only; production strips it)
#===============================================================================
version = meson.project_version()

# In production we always use the clean release version (no git suffix).
if not get_option('production') and get_option('buildtype') != 'release'
    git_command = find_program('git', required : false)

    if git_command.found()
        git_commit = run_command(
            [git_command, 'rev-parse', 'HEAD'],
            check : false
        ).stdout().strip()

        if git_commit != ''
            version += ' (git-' + git_commit.substring(0, 8) + ')'
        endif
    endif
endif
# Production hardening (applied as compile-time defines/flags only)
production = get_option('production')
if production
    if get_option('buildtype') != 'release'
        warning('production=true forces release optimization; buildtype is "@0@"'.format(get_option('buildtype')))
    endif
endif

#===============================================================================
# Configuration
#===============================================================================
conf_data = configuration_data()
conf_data.set('PROJECT_BUILD_DIR', meson.project_build_root())
conf_data.set('PROJECT_SOURCE_DIR', meson.current_source_dir())
conf_data.set('PROJECT_ROOT_DIR', meson.global_source_root())
conf_data.set('PROJECT_VERSION', version)
conf_data.set('PROJECT_ASSEMBLY_VERSION', meson.project_version() + '.0')

#===============================================================================
# Compiler Settings
#===============================================================================
cc = meson.get_compiler('c')

lite_includes = []
lite_cargs = [
    '-DPCRE2_STATIC',
    '-DLITE_PROJECT_VERSION_STR="@0@"'.format(version)
]
if production
    # Common hardening; compilers without these just warn via warning_level.
    # These are harmless on GCC/Clang/MSVC (MSVC ignores /fstack-protector).
    lite_cargs += [
        '-D_FORTIFY_SOURCE=3',
        '-fstack-protector-strong',
        '-DNDEBUG',
    ]
endif
# On macos we need to use the SDL renderer to support retina displays
if get_option('renderer') or host_machine.system() == 'darwin'
    lite_cargs += '-DLITE_USE_SDL_RENDERER'
endif
if get_option('arch_tuple') != ''
    arch_tuple = get_option('arch_tuple')
else
    arch_tuple = '@0@-@1@'.format(target_machine.cpu_family(), target_machine.system())
endif
lite_cargs += '-DLITE_ARCH_TUPLE="@0@"'.format(arch_tuple)

#===============================================================================
# Linker Settings
#===============================================================================
lite_link_args = []
if host_machine.system() == 'darwin'
    lite_link_args += ['-framework', 'CoreServices', '-framework', 'Foundation']
endif
if production
    # Strip + hardening at link time (ignored where unsupported).
    if host_machine.system() == 'linux' or host_machine.system() == 'freebsd'
        lite_link_args += ['-Wl,-z,relro,-z,now']
    endif
endif
#===============================================================================
# Install Configuration
#===============================================================================
if get_option('portable')
    lite_bindir = '/'
    lite_docdir = '/doc'
    lite_datadir = '/data'
    lpm_userdir = 'data'
    lpm_install_dir = '/'
    if host_machine.system() == 'windows'
        configure_file(
            input: 'resources' / 'windows' / 'tcode.exe.manifest.in',
            output: 'tcode.exe.manifest',
            configuration: conf_data
        )
    endif
elif host_machine.system() == 'darwin' and get_option('bundle')
    lite_cargs += '-DMACOS_USE_BUNDLE'
    lite_bindir = 'Contents' / 'MacOS'
    lite_docdir = 'Contents' / 'Resources'
    lite_datadir = 'Contents' / 'Resources'
    lpm_userdir = 'Resources'
    lpm_install_dir = 'Contents'
    conf_data.set(
        'CURRENT_YEAR',
        run_command('date', '+%Y', capture: true).stdout().strip()
    )
    install_data('resources' / 'icons' / 'icon.icns', install_dir : 'Contents' / 'Resources')
    configure_file(
        input : 'resources' / 'macos' / 'Info.plist.in',
        output : 'Info.plist',
        configuration : conf_data,
        install : true,
        install_dir : 'Contents'
    )
elif host_machine.system() == 'windows'
    # Windows installable (InnoSetup) reuses the portable payload layout:
    # exe + data/ + doc/ at the install root {app}. The installer adds
    # shortcuts/PATH/registry; no FHS layout is needed.
    lite_bindir = '/'
    lite_docdir = '/doc'
    lite_datadir = '/data'
    lpm_userdir = 'data'
    lpm_install_dir = '/'
    configure_file(
        input: 'resources' / 'windows' / 'tcode.exe.manifest.in',
        output: 'tcode.exe.manifest',
        configuration: conf_data
    )
else
    # Linux / FreeBSD / installable FHS layout
    lite_bindir = 'bin'
    lite_docdir = get_option('datadir') / 'doc' / 'tcode'
    lite_datadir = get_option('datadir') / 'tcode'
    lpm_userdir = 'tcode'
    lpm_install_dir = get_option('datadir')
    # Windows manifest is needed for the portable payload as well
    if host_machine.system() == 'windows'
        configure_file(
            input: 'resources' / 'windows' / 'tcode.exe.manifest.in',
            output: 'tcode.exe.manifest',
            configuration: conf_data
        )
    endif

    if host_machine.system() == 'linux'
        git_command = find_program('git', required : false)

        if git_command.found()
            git_tags = run_command(
                [git_command, 'tag', '-l', '--sort=-version:refname', '--format=%(refname:strip=2) %(creatordate:short)'],
                check : false
            ).stdout().split('\n')

            releases = []

            foreach tag : git_tags
                taga = tag.split(' ')
                if taga.length() != 2
                    continue
                endif

                ref = taga[0]
                date = taga[1]
                if not ref.startswith('v') or ref.contains('-')
                    continue
                endif

                if ref.startswith('v1.0')
                    # releases 1.01 to 1.09 used an invalid versioning scheme so we ignore them
                    continue
                endif

                releases += '<release version="@0@" date="@1@" />'.format(ref, date)
            endforeach

            releases_tag = ''
            if releases.length() > 0
                releases_tag = '<releases>\n@0@\n</releases>'.format('\n'.join(releases))
            endif

            conf_data.set('METAINFO_RELEASES', releases_tag)
        else
            conf_data.set('METAINFO_RELEASES', '')
        endif

        install_data('resources' / 'icons' / 'tcode.svg',
            install_dir : get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps'
        )
        install_data('resources' / 'linux' / 'dev.thinakaran.tcode.desktop',
            install_dir : get_option('datadir') / 'applications'
        )
        configure_file(
            input : 'resources' / 'linux' / 'dev.thinakaran.tcode.metainfo.xml.in',
            output : 'dev.thinakaran.tcode.metainfo.xml',
            configuration : conf_data,
            install : true,
            install_dir : get_option('datadir') / 'metainfo'
        )
        install_data('resources' / 'linux' / 'tcode.1',
            install_dir : get_option('datadir') / 'man' / 'man1'
        )
    endif
endif

# In portable/bundle layouts the docs live at /doc or Contents/Resources;
# in installable Linux layout they live at share/doc/tcode.
install_data('licenses' / 'licenses.md', install_dir : lite_docdir)
install_data(meson.global_source_root() / 'LICENSE', install_dir : lite_docdir)

install_subdir('docs' / 'api' , install_dir : lite_datadir, strip_directory: true)
install_subdir('data' / 'core' , install_dir : lite_datadir, exclude_files : 'start.lua')
foreach data_module : ['fonts', 'plugins', 'colors', 'icons']
    install_subdir(join_paths('data', data_module), install_dir : lite_datadir)
endforeach

configure_file(
    input : 'data' / 'core' / 'start.lua',
    output : 'start.lua',
    configuration : conf_data,
    install_dir : join_paths(lite_datadir, 'core'),
)

if not get_option('source-only')
    subdir('src')
    subdir('scripts')
    subdir('data')
endif
