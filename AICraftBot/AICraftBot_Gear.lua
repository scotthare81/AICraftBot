DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[AICraftBot]|r TOP OF FILE")
------------------------------------------------------------
-- AICraftBot Gear
------------------------------------------------------------

AICraftBotGear = {}

------------------------------------------------------------
-- Gear Tiers
------------------------------------------------------------

AICraftBotGear.Tiers = {
    [0] = {
        id = 0,
        name = "Fresh 60",
    },

    [1] = {
        id = 1,
        name = "Pre-BiS",
    },

    [2] = {
        id = 2,
        name = "Molten Core",
    },

    [3] = {
        id = 3,
        name = "Blackwing Lair",
    },

    [4] = {
        id = 4,
        name = "AQ40",
    },

    [5] = {
        id = 5,
        name = "Naxxramas",
    },
}

------------------------------------------------------------
-- Current Selection
------------------------------------------------------------

AICraftBotGear.SelectedTier = 1

------------------------------------------------------------
-- Functions
------------------------------------------------------------

function AICraftBotGear:GetTier()
    return self.SelectedTier
end

function AICraftBotGear:SetTier(tier)
    self.SelectedTier = tier
end

function AICraftBotGear:GetTierName()
    local tier = self.Tiers[self.SelectedTier]

    if tier then
        return tier.name
    end

    return "Unknown"
end

------------------------------------------------------------
-- Startup
------------------------------------------------------------

DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[AICraftBot]|r Gear module loaded.")
