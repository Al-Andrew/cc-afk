local cmdline = {}

---@class cmdline.Command 
---@field command string The name of the command, and the first argument to the script
---@field description string A description of the command, used for help output
---@field args table<string, string> A table of argument names and their descriptions
---@field func fun(...) The handler for the command, will be called with the rest of the arguments


--- Prints help information for all commands in the cmdline table.
---@param cmdline_table table<string, cmdline.Command> A table of commands
function cmdline.help(cmdline_table)
    print("Available commands:")
    for name, command in pairs(cmdline_table) do
        print(string.format("%s: %s", name, command.description))
        if command.args then
            for arg_name, arg_desc in pairs(command.args) do
                print(string.format("  --%s: %s", arg_name, arg_desc))
            end
        end
    end
end

--- Errors out priting the error message and help information.
---@param message string The error message to print
---@param cmdline_table table<string, cmdline.Command> A table of commands
function cmdline.error_with_help(message, cmdline_table)
    cmdline.help(cmdline_table)
    error("Error: " .. message)
end

---@param cmdline_table table<string, cmdline.Command> A table of commands
---@param arg string[] The arguments passed to the script
function cmdline.run(cmdline_table, arg)
    if #arg < 1 then
        cmdline.error_with_help("No command provided. Use 'help' to see available commands.", cmdline_table)
    end

    local command_name = arg[1]
    local command = cmdline_table[command_name]

    if not command then
        cmdline.error_with_help("Unknown command: " .. command_name, cmdline_table)
    end

    -- Remove the command name from the arguments
    table.remove(arg, 1)

    -- Call the command function with the remaining arguments
    command.func(table.unpack(arg))
end

return cmdline