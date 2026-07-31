AICraftBot = AICraftBot or {}

function AICraftBot.CreateDiagnosticsTab(parent)
    return AICraftBot.Tabs.CreatePanel(
        parent,
        "Diagnostics",
        "Diagnostics"
    )
end
