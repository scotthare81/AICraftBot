AICraftBot = AICraftBot or {}
AICraftBot.UI = AICraftBot.UI or {}

function AICraftBot.UI.SetTooltip(frame, title, text)
    if not frame then
        return
    end

    frame:SetScript("OnEnter", function()
        GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
        GameTooltip:SetText(title or "AICraftBot", 1, 0.82, 0)

        if text and text ~= "" then
            GameTooltip:AddLine(text, 1, 1, 1, true)
        end

        GameTooltip:Show()
    end)

    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end
