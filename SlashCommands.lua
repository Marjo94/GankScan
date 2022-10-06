SLASH_GANKSCAN1 = "/gankscan"
SlashCmdList["GANKSCAN"] = function(msg)
    local action, name = msg:match("^(%S*)%s*(.-)$")

    if action == "add" then
        GankScan.AddTarget(name)
    elseif action == "remove" then
        GankScan.RemoveTarget(name)
    end
end

SLASH_GANKSCAN2 = "/gs"
SlashCmdList["GS"] = function(msg)
    local action, name = msg:match("^(%S*)%s*(.-)$")

    if action == "add" then
        GankScan.AddTarget(name)
    elseif action == "remove" then
        GankScan.RemoveTarget(name)
    end
end

SLASH_TEST1 = "/test"
SlashCmdList["TEST"] = function()
    GankScan.Scan()
end
