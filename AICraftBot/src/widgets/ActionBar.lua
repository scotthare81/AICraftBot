AICraftBot = AICraftBot or {}
AICraftBot.Widgets = AICraftBot.Widgets or {}

function AICraftBot.Widgets.CreateActionBar(parent, options)
    local bar = CreateFrame("Frame", nil, parent)

    options = options or {}

    bar:SetWidth(options.width or 330)
    bar:SetHeight(options.height or 120)

    bar:SetPoint(
        options.point or "TOPLEFT",
        options.relativeTo or parent,
        options.relativePoint or "TOPLEFT",
        options.x or 0,
        options.y or 0
    )

    bar.buttons = {}

    function bar:AddCommandButton(text, command)
        local index = table.getn(self.buttons)

        local button = CreateFrame(
            "Button",
            nil,
            self,
            "UIPanelButtonTemplate"
        )

        button:SetWidth(100)
        button:SetHeight(24)

        local column = math.mod(index, 3)
        local row = math.floor(index / 3)

        button:SetPoint(
            "TOPLEFT",
            self,
            "TOPLEFT",
            column * 105,
            -(row * 28)
        )

        button:SetText(text)
        button.command = command

        button:SetScript("OnClick", function()
            AICraftBot.Legacy.SendCommand(this.command)
        end)

        AICraftBot.UI.SetTooltip(
            button,
            text,
            "Send '" .. command .. "' to all selected bots."
        )

        table.insert(self.buttons, button)

        return button
    end

    return bar
end
