GankScan = CreateFrame("Frame")
GankTargets = {}
GankScan:RegisterEvent("ADDON_LOADED")
GankScan:RegisterEvent("ADDON_ACTION_FORBIDDEN")
GankScan:RegisterEvent("PLAYER_TARGET_CHANGED")
local BROWN = {.7, .15, .05}
local YELLOW = {1, 1, .15}

-- Load
do

    function GankScan.Load()
        UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN")
        do
            if not GankTargets then
                GankTargets = {}
            end

            local Flash = CreateFrame("Frame")
            GankScan.Flash = Flash
            Flash:Show()
            Flash:SetAllPoints()
            Flash:SetAlpha(0)
            Flash:SetFrameStrata 'FULLSCREEN_DIALOG'

            local texture = Flash:CreateTexture()
            texture:SetBlendMode 'ADD'
            texture:SetAllPoints()
            texture:SetTexture [[Interface\FullScreenTextures\LowHealth]]

            Flash.Animation = CreateFrame("Frame")
            Flash.Animation:Hide()
            Flash.Animation:SetScript('OnUpdate', function(self)
                local t = GetTime() - self.t0
                if t <= .5 then
                    Flash:SetAlpha(t * 2)
                elseif t <= 1 then
                    Flash:SetAlpha(1)
                elseif t <= 1.5 then
                    Flash:SetAlpha(1 - (t - 1) * 2)
                else
                    Flash:SetAlpha(0)
                    self.loops = self.loops - 1
                    if self.loops == 0 then
                        self.t0 = nil
                        self:Hide()
                    else
                        self.t0 = GetTime()
                    end
                end
            end)
            function Flash.Animation:Play()
                if self.t0 then
                    self.loops = 4
                else
                    self.t0 = GetTime()
                    self.loops = 3
                end
                self:Show()
            end
            local button = CreateFrame('Button', 'GankScanButton', UIParent,
                'SecureActionButtonTemplate, BackdropTemplate')
            button:SetAttribute('type', 'macro')
            button:Hide()
            GankScan.button = button
            button:SetPoint('BOTTOM', UIParent, 0, 128)
            button:SetWidth(150)
            button:SetHeight(42)
            button:SetScale(1.25)
            button:SetMovable(true)
            button:SetUserPlaced(true)
            button:SetClampedToScreen(true)
            button:SetScript('OnMouseDown', function(self)
                if IsControlKeyDown() then
                    self:RegisterForClicks()
                    self:StartMoving()
                end
            end)
            button:SetScript('OnMouseUp', function(self)
                self:StopMovingOrSizing()
                self:RegisterForClicks 'LeftButtonDown'
            end)
            button:SetFrameStrata 'FULLSCREEN_DIALOG'
            button:SetNormalTexture [[Interface\AddOns\GankScan\Assets\Texture\UI-Achievement-Parchment-Horizontal]]
            button:SetBackdrop{
                tile = true,
                edgeSize = 16,
                edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]]
            }
            button:SetBackdropBorderColor(unpack(BROWN))
            button:SetScript('OnEnter', function(self)
                self:SetBackdropBorderColor(unpack(YELLOW))
            end)
            button:SetScript('OnLeave', function(self)
                self:SetBackdropBorderColor(unpack(BROWN))
            end)
            function button:set_target(name)
                self:SetText(name)
                self:SetAttribute('macrotext', '/cleartarget\n/targetexact ' .. name)
                self:Show()
                self.glow.animation:Play()
                self.shine.animation:Play()
            end

            do
                local background = button:GetNormalTexture()
                background:SetDrawLayer 'BACKGROUND'
                background:ClearAllPoints()
                background:SetPoint('BOTTOMLEFT', 3, 3)
                background:SetPoint('TOPRIGHT', -3, -3)
                background:SetTexCoord(0, 1, 0, .25)
            end

            do
                local title_background = button:CreateTexture(nil, 'BORDER')
                title_background:SetTexture [[Interface\AddOns\GanKscan\Assets\Texture\UI-Achievement-Title]]
                title_background:SetPoint('TOPRIGHT', -5, -5)
                title_background:SetPoint('LEFT', 5, 0)
                title_background:SetHeight(18)
                title_background:SetTexCoord(0, .9765625, 0, .3125)
                title_background:SetAlpha(.8)

                local title = button:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightMedium')
                title:SetWordWrap(false)
                title:SetPoint('TOPLEFT', title_background, 0, 0)
                title:SetPoint('RIGHT', title_background)
                button:SetFontString(title)

                local subtitle = button:CreateFontString(nil, 'OVERLAY', 'GameFontBlackTiny')
                subtitle:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -4)
                subtitle:SetPoint('RIGHT', title)
                subtitle:SetText 'Unit Found!'
            end

            do
                local model = CreateFrame('PlayerModel', nil, button)
                button.model = model
                model:SetPoint('BOTTOMLEFT', button, 'TOPLEFT', 0, -4)
                model:SetPoint('RIGHT', 0, 0)
                model:SetHeight(button:GetWidth() * .6)
            end

            do
                local close = CreateFrame('Button', nil, button, 'UIPanelCloseButton')
                close:SetPoint('TOPRIGHT', 0, 0)
                close:SetWidth(32)
                close:SetHeight(32)
                close:SetScale(.8)
                close:SetHitRectInsets(8, 8, 8, 8)
            end

            do
                local glow = button.model:CreateTexture(nil, 'OVERLAY')
                button.glow = glow
                glow:SetPoint('CENTER', button, 'CENTER')
                glow:SetWidth(400 / 300 * button:GetWidth())
                glow:SetHeight(171 / 70 * button:GetHeight())
                glow:SetTexture [[Interface\AddOns\GankScan\Assets\Texture\UI-Achievement-Alert-Glow]]
                glow:SetBlendMode 'ADD'
                glow:SetTexCoord(0, .78125, 0, .66796875)
                glow:SetAlpha(0)

                glow.animation = CreateFrame 'Frame'
                glow.animation:Hide()
                glow.animation:SetScript('OnUpdate', function(self)
                    local t = GetTime() - self.t0
                    if t <= .2 then
                        glow:SetAlpha(t * 5)
                    elseif t <= .7 then
                        glow:SetAlpha(1 - (t - .2) * 2)
                    else
                        glow:SetAlpha(0)
                        self:Hide()
                    end
                end)
                function glow.animation:Play()
                    self.t0 = GetTime()
                    self:Show()
                end
            end

            do
                local shine = button:CreateTexture(nil, 'ARTWORK')
                button.shine = shine
                shine:SetPoint('TOPLEFT', button, 0, 8)
                shine:SetWidth(67 / 300 * button:GetWidth())
                shine:SetHeight(1.28 * button:GetHeight())
                shine:SetTexture [[Interface\AddOns\GankScan\Assets\Texture\UI-Achievement-Alert-Glow]]
                shine:SetBlendMode 'ADD'
                shine:SetTexCoord(.78125, .912109375, 0, .28125)
                shine:SetAlpha(0)

                shine.animation = CreateFrame 'Frame'
                shine.animation:Hide()
                shine.animation:SetScript('OnUpdate', function(self)
                    local t = GetTime() - self.t0
                    if t <= .3 then
                        shine:SetPoint('TOPLEFT', button, 0, 8)
                    elseif t <= .7 then
                        shine:SetPoint('TOPLEFT', button, (t - .3) * 2.5 * self.distance, 8)
                    end
                    if t <= .3 then
                        shine:SetAlpha(0)
                    elseif t <= .5 then
                        shine:SetAlpha(1)
                    elseif t <= .7 then
                        shine:SetAlpha(1 - (t - .5) * 5)
                    else
                        shine:SetAlpha(0)
                        self:Hide()
                    end
                end)
                function shine.animation:Play()
                    self.t0 = GetTime()
                    self.distance = button:GetWidth() - shine:GetWidth() + 8
                    self:Show()
                end
            end
        end
    end
end
-- 