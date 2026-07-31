AICraftBot = AICraftBot or {}

function AICraftBot.CreateCommandsTab(parent)
    local frame = AICraftBot.Tabs.CreatePanel(
        parent,
        "Commands",
        "Quick Commands"
    )

    local movementTitle = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )
    movementTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -55)
    movementTitle:SetText("Movement")

    local movementBar = AICraftBot.Widgets.CreateActionBar(
        frame,
        {
            x = 20,
            y = -80,
            width = 330,
            height = 55,
        }
    )

    movementBar:AddCommandButton("Follow", "follow")
    movementBar:AddCommandButton("Stay", "stay")
    movementBar:AddCommandButton("Guard", "guard")
    movementBar:AddCommandButton("Free", "free")
    movementBar:AddCommandButton("Flee", "flee")
    movementBar:AddCommandButton("Return", "return")

    local combatTitle = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )
    combatTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -150)
    combatTitle:SetText("Combat")

    local combatBar = AICraftBot.Widgets.CreateActionBar(
        frame,
        {
            x = 20,
            y = -175,
            width = 330,
            height = 55,
        }
    )

    combatBar:AddCommandButton("Attack", "attack")
    combatBar:AddCommandButton("Pull", "pull")
    combatBar:AddCommandButton("Tank Attack", "tank attack")
    combatBar:AddCommandButton("No Delay", "wait for attack time 0")
    combatBar:AddCommandButton("2 sec Delay", "wait for attack time 2")
    combatBar:AddCommandButton("5 sec Delay", "wait for attack time 5")

    local supportTitle = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )
    supportTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -245)
    supportTitle:SetText("Support")

    local supportBar = AICraftBot.Widgets.CreateActionBar(
        frame,
        {
            x = 20,
            y = -270,
            width = 330,
            height = 55,
        }
    )

    supportBar:AddCommandButton("Repair", "repair")
    supportBar:AddCommandButton("Ready Check", "ready check")
    supportBar:AddCommandButton("Buff", "buff")
    supportBar:AddCommandButton("Save Mana", "save mana")
    supportBar:AddCommandButton("Revive", "revive target")
    supportBar:AddCommandButton("Reset AI", "reset ai soft")

    local strategyTitle = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )
    strategyTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 370, -55)
    strategyTitle:SetText("Combat Style")

    local strategyBar = AICraftBot.Widgets.CreateActionBar(
        frame,
        {
            x = 370,
            y = -80,
            width = 105,
            height = 85,
        }
    )

    strategyBar:AddCommandButton("AoE On", "co +aoe")
    strategyBar:AddCommandButton("AoE Off", "co -aoe")
    strategyBar:AddCommandButton("Max DPS", "max dps")

    return frame
end
