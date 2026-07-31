AICraftBot = AICraftBot or {}

function AICraftBot.CreateDashboard(parent)
    local frame = AICraftBot.Tabs.CreatePanel(
        parent,
        "Dashboard",
        "Dashboard"
    )

    local subtitle = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlight"
    )

    subtitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -50)
    subtitle:SetText("AICraftBot modular interface")

    local names = {
        "Bots",
        "Roster",
        "Raid",
        "Strategies",
        "Commands",
        "Specs",
        "Gear",
        "Encounters",
        "Diagnostics",
        "Settings",
    }

    local index

    for index = 1, table.getn(names) do
        local name = names[index]
        local button = CreateFrame(
            "Button",
            nil,
            frame,
            "UIPanelButtonTemplate"
        )

        button:SetWidth(125)
        button:SetHeight(28)

        local column = math.mod(index - 1, 2)
        local row = math.floor((index - 1) / 2)

        button:SetPoint(
            "TOPLEFT",
            frame,
            "TOPLEFT",
            20 + (column * 140),
            -85 - (row * 38)
        )

        button:SetText(name)
        button.tabName = name

        button:SetScript("OnClick", function()
            AICraftBot.Tabs.Show(this.tabName)
        end)

        AICraftBot.UI.SetTooltip(
            button,
            name,
            "Opens the " .. name .. " module."
        )
    end

    return frame
end
