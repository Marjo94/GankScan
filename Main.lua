local CHECK_INTERVAL = 5
local foundTarget = false
local runAddon = false

GankScan:SetScript('OnUpdate', function()
    if runAddon then
        GankScan.Scan()
    end
end)
GankScan:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "GankScan" then
        GankScan.Load()
    elseif event == 'ADDON_ACTION_FORBIDDEN' and arg1 == 'GankScan' then
        foundTarget = true
    elseif event == "PLAYER_TARGET_CHANGED" then
        if UnitName("target") and strupper(UnitName("target")) == GankScan.button:GetText() and
            not GetRaidTargetIndex("target") and
            (not IsInRaid() or UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
            SetRaidTarget('target', 4)
        end
    end
end);

-- PlaySound
do
    local TimeSoundLastPlayed

    function GankScan.PlaySound()
        if not TimeSoundLastPlayed or GetTime() - TimeSoundLastPlayed > 5 then
            TimeSoundLastPlayed = GetTime()
            PlaySoundFile([[Interface\AddOns\GankScan\Assets\Sound\Hee-hee.ogg]], 'Master')
        end
    end
end
--

-- Scan
do
    GankScan.lastCheckTime = GetTime()
    function GankScan.Scan()
        if GetTime() - GankScan.lastCheckTime >= CHECK_INTERVAL then
            GankScan.lastCheckTime = GetTime()
            for key in pairs(GankTargets) do
                if GankTargets[key] then
                    foundTarget = false

                    local sound_setting = GetCVar 'Sound_EnableAllSound'
                    SetCVar('Sound_EnableAllSound', 0)
                    TargetUnit(key, true)
                    SetCVar('Sound_EnableAllSound', sound_setting)

                    if foundTarget then
                        GankScan.PlaySound()
                        GankScan.Flash.Animation:Play()
                        GankScan.button:set_target(key)
                        GankTargets[key] = false
                    end
                end
            end
        end
    end
end
--