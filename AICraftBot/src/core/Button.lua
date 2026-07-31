AICraftBot = AICraftBot or {}
AICraftBot.UI = AICraftBot.UI or {}

function AICraftBot.UI.CreateButton(parent, text, width, height, onClick, tooltipTitle, tooltipText)
    local button = CreateFrame(
        "Button",
        nil,
        parent,
        "UIPanelButtonTemplate"
    )

    button:SetWidth(width or 100)
    button:SetHeight(height or 22)
    button:SetText(text or "")

    if onClick then
        button:SetScript("OnClick", onClick)
    end

    if AICraftBot.UI.SetTooltip then
        AICraftBot.UI.SetTooltip(
            button,
            tooltipTitle or text,
            tooltipText
        )
    end

    return button
end
