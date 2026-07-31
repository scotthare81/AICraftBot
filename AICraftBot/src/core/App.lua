AICraftBot = AICraftBot or {}

function AICraftBot.InitializeFrameworkTabs(parent)
    if not parent then
        return
    end

    if AICraftBot.FrameworkTabsInitialized then
        return
    end

    AICraftBot.FrameworkTabsInitialized = true
    AICraftBot.FrameworkPanels = {}

    AICraftBot.FrameworkPanels.Dashboard =
        AICraftBot.CreateDashboard(parent)

    AICraftBot.FrameworkPanels.Bots =
        AICraftBot.CreateBotsTab(parent)

    AICraftBot.FrameworkPanels.Roster =
        AICraftBot.CreateRosterTab(parent)

    AICraftBot.FrameworkPanels.Raid =
        AICraftBot.CreateRaidTab(parent)

    AICraftBot.FrameworkPanels.Strategies =
        AICraftBot.CreateStrategiesTab(parent)

    AICraftBot.FrameworkPanels.Commands =
        AICraftBot.CreateCommandsTab(parent)

    AICraftBot.FrameworkPanels.Gear =
        AICraftBot.CreateGearTab(parent)

    AICraftBot.FrameworkPanels.Specs =
        AICraftBot.CreateSpecsTab(parent)

    AICraftBot.FrameworkPanels.Encounters =
        AICraftBot.CreateEncountersTab(parent)

    AICraftBot.FrameworkPanels.Diagnostics =
        AICraftBot.CreateDiagnosticsTab(parent)

    AICraftBot.FrameworkPanels.Settings =
        AICraftBot.CreateSettingsTab(parent)
end
