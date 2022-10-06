-- Interface
GankScan.panel = CreateFrame("Frame", "GankScanPanel", UIParent)
do
    function GankScan.SetupInterfaceSettings()
        GankScan.panel.name = "GankScan"
        InterfaceOptions_AddCategory(GankScan.panel)

        local scrollFrame = CreateFrame("ScrollFrame", nil, GankScan.panel, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 3, -4)
        scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

        local scrollChild = CreateFrame("Frame")
        scrollFrame:SetScrollChild(scrollChild)
        scrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 18)
        scrollChild:SetHeight(1)

        -- Title
        local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
        title:SetPoint("TOP")
        title:SetText(GankScan.panel.name)

        -- Footer
        local footer = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")
        footer:SetPoint("TOP", 0, -500)
        footer:SetText(GankScan.panel.name)
    end
end
--
