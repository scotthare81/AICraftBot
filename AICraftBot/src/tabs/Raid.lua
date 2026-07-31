AICraftBot = AICraftBot or {}

function AICraftBot.CreateRaidTab(parent)
    return AICraftBot.Tabs.CreatePanel(
        parent,
        "Raid",
        "Raid Control"
    )
end
