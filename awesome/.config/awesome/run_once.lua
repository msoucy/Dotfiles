-- Standard awesome library
local awful = require("awful")

function spawn_with_sh(cmd, shell) -- {{{
    --- Spawn a program using sh.
    -- @param cmd The command.
    -- Don't use awful.util.shell, in case the shell isn't bash-compatible
    return awful.util.spawn({
        shell or "/bin/sh", "-c", cmd
    })
end -- }}}

function run_once(prg, arg_string) -- {{{
    if (not prg) or prg == "" then do return nil end end
    local cmd = prg
    if arg_string and arg_string ~= "" then
        cmd = cmd .. " " .. (arg_string or "")
    end
    -- Look for process, if it doesn't exist then spawn it
    return spawn_with_sh(
        "pgrep -f -u $USER -x '" .. cmd .. "' || (" .. cmd .. ")"
    )
end -- }}}

return run_once

-- vim: fdm=marker et ts=4 sw=4
