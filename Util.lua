do
    function GankScan.Print(msg)
        DEFAULT_CHAT_FRAME:AddMessage(msg)
    end
end

function GankScan.AddTarget(name)
    local key = strupper(name)

    if GankTargets[key] ~= true then
        GankTargets[key] = true;
        GankScan.Print(name .. " added to GankScan!")
    elseif GankTargets[key] then
        GankScan.Print(name .. " is already added!")
    end

end

function GankScan.RemoveTarget(name)
    local key = strupper(name)
    if GankTargets[key] then
        GankTargets[key] = false
        GankScan.Print(name .. " was removed from the Gank List!")
    elseif not GankTargets[key] then
        GankScan.Print(name .. " is not on the Gank List!")
    end
end
