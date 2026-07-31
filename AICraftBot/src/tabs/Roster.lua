AICraftBot = AICraftBot or {}

function AICraftBot.CreateRosterTab(parent)
    local frame = AICraftBot.Tabs.CreatePanel(
        parent,
        "Roster",
        "Active Bot Roster"
    )

    local description = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlight"
    )

    description:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -52)
    description:SetWidth(520)
    description:SetJustifyH("LEFT")
    description:SetText(
        "Select bots currently detected in your party or raid."
    )

    frame.selectionList =
        AICraftBot.Widgets.CreateSelectionList(
            frame,
            {
                x = 20,
                y = -82,
                width = 350,
                height = 250,
                visibleRows = 10,
                rowHeight = 23,

                tooltipText =
                    "Currently in your party or raid.",

                isSelected = function(bot)
                    return AICraftBot.Legacy.IsActiveBotSelected(
                        bot.name
                    )
                end,

                onSelectionChanged = function(bot, selected)
                    AICraftBot.Legacy.SetActiveBotSelected(
                        bot.name,
                        selected
                    )

                    frame:UpdateSelectionCount()
                end,
            }
        )

    frame.countLabel = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

    frame.countLabel:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -90
    )

    frame.countLabel:SetText("Active bots: 0")

    frame.selectedLabel = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlight"
    )

    frame.selectedLabel:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -115
    )

    frame.selectedLabel:SetText("Selected: 0")

    local selectAllButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    selectAllButton:SetWidth(150)
    selectAllButton:SetHeight(28)
    selectAllButton:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -150
    )

    selectAllButton:SetText("Select All")

    selectAllButton:SetScript("OnClick", function()
        AICraftBot.Legacy.SelectAllActiveBots()
        frame.selectionList:Refresh()
        frame:UpdateSelectionCount()
    end)

    AICraftBot.UI.SetTooltip(
        selectAllButton,
        "Select All",
        "Selects every active bot in your party or raid."
    )

    local clearButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    clearButton:SetWidth(150)
    clearButton:SetHeight(28)
    clearButton:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -185
    )

    clearButton:SetText("Clear Selection")

    clearButton:SetScript("OnClick", function()
        AICraftBot.Legacy.ClearActiveBotSelection()
        frame.selectionList:Refresh()
        frame:UpdateSelectionCount()
    end)

    AICraftBot.UI.SetTooltip(
        clearButton,
        "Clear Selection",
        "Clears the active-bot selection."
    )

    local refreshButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    refreshButton:SetWidth(150)
    refreshButton:SetHeight(28)
    refreshButton:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -220
    )

    refreshButton:SetText("Refresh Roster")

    refreshButton:SetScript("OnClick", function()
        AICraftBot.Legacy.RefreshActiveRoster()
        frame:RefreshRoster()
    end)

    AICraftBot.UI.SetTooltip(
        refreshButton,
        "Refresh Roster",
        "Rebuilds the roster from your current party or raid."
    )

    local commandsButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    commandsButton:SetWidth(150)
    commandsButton:SetHeight(28)
    commandsButton:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -255
    )

    commandsButton:SetText("Quick Commands")

    commandsButton:SetScript("OnClick", function()
        AICraftBot.Legacy.ShowCommands()
    end)

    AICraftBot.UI.SetTooltip(
        commandsButton,
        "Quick Commands",
        "Opens commands for the selected active bots."
    )

    function frame:UpdateSelectionCount()
        self.selectedLabel:SetText(
            "Selected: " ..
            AICraftBot.Legacy.GetSelectedActiveBotCount()
        )
    end

    function frame:RefreshRoster()
        local roster =
            AICraftBot.Legacy.GetActiveRoster() or {}

        self.countLabel:SetText(
            "Active bots: " .. table.getn(roster)
        )

        self.selectionList:SetItems(roster)
        self:UpdateSelectionCount()
    end

    frame:SetScript("OnShow", function()
        frame:RefreshRoster()
    end)

    return frame
end
