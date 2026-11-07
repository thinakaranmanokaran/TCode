---@meta

---
---A pseudo-terminal backed by the operating system's PTY (POSIX) or
---ConPTY (Windows) implementation, together with a small xterm-compatible
---screen buffer and escape-sequence parser.
---
---The terminal is exposed as a native module and is used by the bundled
---`terminal` plugin. On Windows, ConPTY requires Windows 10 version 1809
---or newer.
---
---@class terminal
---@field public version string Version of the vendored terminal backend.
terminal = {}

---
---Options used when creating a terminal.
---
---@class terminal.options
---@field public columns integer Number of character cells per line.
---@field public lines integer Number of visible lines.
---@field public scrollback integer Maximum number of scrollback lines to retain.
---@field public term string Value advertised through the TERM environment variable, e.g. `"xterm-256color"`.
---@field public shell string Absolute path to the shell executable. Use `"DUMMY"` to create a terminal that does not spawn a process.
---@field public arguments? string[] Arguments passed to the shell. On Windows the executable and arguments are combined into a command line.
---@field public environment? table<string, string>|string Environment variables. On Windows this must be a NUL-separated `KEY=VALUE` block terminated by two NUL bytes.
---@field public cwd? string Working directory for the shell. Defaults to the current process directory.
---@field public debug? boolean When true, writes terminal output to `terminal.log`.

---
---Create a new terminal instance.
---
---The returned object owns the child process and the PTY/ConPTY handles.
---Call `terminal:close()` when it is no longer needed; the garbage collector
---will also close it.
---
---@param columns integer
---@param lines integer
---@param scrollback integer
---@param term string
---@param shell string
---@param arguments? string[]
---@param environment? table<string, string>|string
---@param debug? boolean
---@param cwd? string
---@return terminal|nil
---@return string? error
function terminal.new(columns, lines, scrollback, term, shell, arguments, environment, debug, cwd) end

---
---Send bytes to the child process.
---
---@param data string
function terminal:input(data) end

---
---Read and parse all currently available output from the child process.
---
---When `callback` is provided it is called once per available chunk. The
---return value is the number of lines that scrolled out of the visible buffer,
---or `false` when no output was available.
---
---@param callback? fun(chunk: string)
---@return integer|false
function terminal:update(callback) end

---
---Return the styled content of a range of lines.
---
---Each entry is a table that alternates between a packed color/style integer
---and a UTF-8 text string. A line may lack a trailing newline when the line
---wrapped in the terminal.
---
---@param first? integer First line, relative to the scrollback position. Defaults to the top of the visible buffer.
---@param last? integer Last line, inclusive. Defaults to the bottom of the visible buffer.
---@return table<integer, integer|string>[]
function terminal:lines(first, last) end

---
---Get or set the terminal dimensions. When setting, the child process is
---notified through `TIOCSWINSZ` or `ResizePseudoConsole`.
---
---@param columns? integer
---@param lines? integer
---@return integer columns
---@return integer lines
function terminal:size(columns, lines) end

---
---Get or set the scrollback position.
---
---@param position? integer Number of lines to scroll back; 0 means the live buffer.
---@return integer position
---@return integer total
function terminal:scrollback(position) end

---
---Get the cursor position and rendering mode.
---
---@return integer x
---@return integer y
---@return "solid"|"hidden"|"blinking" mode
function terminal:cursor() end

---
---Enable or disable focus reporting to the child process.
---
---@param focused boolean
function terminal:focused(focused) end

---
---Get the mouse tracking mode requested by the running application.
---
---@return "x10"|"normal"|"sgr"|nil
function terminal:mouse_tracking_mode() end

---
---Get the cursor key mode requested by the running application.
---
---@return "normal"|"application"
function terminal:cursor_keys_mode() end

---
---Get the keypad key mode requested by the running application.
---
---@return "normal"|"application"
function terminal:keypad_keys_mode() end

---
---Get the paste mode requested by the running application.
---
---@return "normal"|"bracketed"
function terminal:paste_mode() end

---
---Get the window title reported by the running application.
---
---@return string|nil
function terminal:name() end

---
---Get the parent process environment as key/value pairs.
---
---This method is only available on Windows.
---
---@return table<string, string>
function terminal:getenv() end

---
---Check whether the child process has exited.
---
---On POSIX this returns `(exit_code, signal)` when the process has exited.
---On Windows only the exit code is returned.
---
---@return integer|false
---@return integer?
function terminal:exited() end

---
---Clear the screen buffer and scrollback.
---
function terminal:clear() end

---
---Close the pseudo-terminal and terminate the child process.
---
---@return integer status `0` on success.
function terminal:close() end

return terminal
