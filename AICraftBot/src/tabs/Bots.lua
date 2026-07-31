AICraftBot = AICraftBot or {}

function AICraftBot.CreateBotsTab(parent)
    local frame = AICraftBot.Tabs.CreatePanel(
        parent,
        "Bots",
        "Bot Deployment"
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
        "Select offline characters and deploy them as active bots."
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
                    "Available character for bot deployment.",

                isSelected = function(bot)
                    return AICraftBot.Legacy.IsDeployBotSelected(
                        bot.name
                    )
                end,

                onSelectionChanged = function(bot, selected)
                    if bot.online then
                        AICraftBot.UI.ShowMessage(
                            bot.name .. " is already online."
                        )

                        frame.selectionList:Refresh()
                        return
                    end

                    AICraftBot.Legacy.SetDeployBotSelected(
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

    frame.countLabel:SetText("Known bots: 0")

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

    selectAllButton:SetText("Select Offline")

    selectAllButton:SetScript("OnClick", function()
        AICraftBot.Legacy.SelectAllDeployBots()
        frame.selectionList:Refresh()
        frame:UpdateSelectionCount()
    end)

    AICraftBot.UI.SetTooltip(
        selectAllButton,
        "Select Offline",
        "Selects every available character that is currently offline."
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
        AICraftBot.Legacy.ClearDeployBotSelection()
        frame.selectionList:Refresh()
        frame:UpdateSelectionCount()
    end)

    AICraftBot.UI.SetTooltip(
        clearButton,
        "Clear Selection",
        "Clears the deployment selection."
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

    refreshButton:SetText("Refresh Bot List")

    refreshButton:SetScript("OnClick", function()
        frame:RefreshAvailableBots()
    end)

    AICraftBot.UI.SetTooltip(
        refreshButton,
        "Refresh Bot List",
        "Requests an updated character list from the server."
    )

    local deployButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    deployButton:SetWidth(150)
    deployButton:SetHeight(32)
    deployButton:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -260
    )

    deployButton:SetText("Deploy Selected")

    deployButton:SetScript("OnClick", function()
        AICraftBot.Legacy.DeploySelected()
    end)

    AICraftBot.UI.SetTooltip(
        deployButton,
        "Deploy Selected",
        "Logs in every selected offline bot and invites them to your group."
    )

    local legacyButton = CreateFrame(
        "Button",
        nil,
        frame,
        "UIPanelButtonTemplate"
    )

    legacyButton:SetWidth(150)
    legacyButton:SetHeight(28)
    legacyButton:SetPoint(
        "TOPLEFT",
        frame,
        "TOPLEFT",
        390,
        -305
    )

    legacyButton:SetText("Legacy Deploy View")

    legacyButton:SetScript("OnClick", function()
        AICraftBot.Legacy.ShowDeploy()
    end)

    AICraftBot.UI.SetTooltip(
        legacyButton,
        "Legacy Deploy View",
        "Opens the original deployment interface."
    )

    function frame:UpdateSelectionCount()
        self.selectedLabel:SetText(
            "Selected: " ..
            AICraftBot.Legacy.GetSelectedDeployBotCount()
        )
    end

    function frame:SetAvailableBots(roster)
        roster = roster or {}

        self.countLabel:SetText(
            "Known bots: " .. table.getn(roster)
        )

        self.selectionList:SetItems(roster)
        self:UpdateSelectionCount()
    end

    function frame:RefreshAvailableBots()
        self.countLabel:SetText("Requesting bot list...")

        AICraftBot.Legacy.RefreshAvailableRoster(
            function(roster)
                frame:SetAvailableBots(roster)
            end
        )
    end

    frame:SetScript("OnShow", function()
        local roster =
            AICraftBot.Legacy.GetAvailableRoster() or {}

        frame:SetAvailableBots(roster)

        if table.getn(roster) == 0 then
            frame:RefreshAvailableBots()
        end
    end)

    return frame
end
