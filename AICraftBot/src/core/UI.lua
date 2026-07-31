AICraftBot = AICraftBot or {}
AICraftBot.UI = AICraftBot.UI or {}

function AICraftBot.UI.ShowMessage(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99AICraftBot:|r " .. text)
end

function AICraftBot.UI.Error(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cffff4040AICraftBot:|r " .. text)
end
