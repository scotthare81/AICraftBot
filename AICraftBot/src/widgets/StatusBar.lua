AICraftBot = AICraftBot or {}
AICraftBot.Widgets = AICraftBot.Widgets or {}

function AICraftBot.Widgets.CreateStatusBar(parent, options)
    local status = CreateFrame("Frame", nil, parent)

    status:SetWidth(options.width or 220)
    status:SetHeight(options.height or 22)
    status:SetPoint(
        options.point or "TOPLEFT",
        options.relativeTo or parent,
        options.relativePoint or "TOPLEFT",
        options.x or 0,
        options.y or 0
    )

    status.label = status:CreateFontString(
        nil,
        "OVERLAY",
        options.font or "GameFontHighlight"
    )

    status.label:SetPoint("LEFT", status, "LEFT", 0, 0)
    status.label:SetText(options.text or "")

    function status:SetText(text)
        self.label:SetText(text or "")
    end

    function status:SetCount(count, suffix)
        self.label:SetText(
            tostring(count or 0) .. " " .. (suffix or "selected")
        )
    end

    return status
end
