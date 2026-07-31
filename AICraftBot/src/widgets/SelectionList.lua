AICraftBot = AICraftBot or {}
AICraftBot.Widgets = AICraftBot.Widgets or {}

function AICraftBot.Widgets.CreateSelectionList(parent, options)
    options = options or {}

    local list = CreateFrame("Frame", nil, parent)

    list:SetWidth(options.width or 260)
    list:SetHeight(options.height or 260)

    list:SetPoint(
        options.point or "TOPLEFT",
        options.relativeTo or parent,
        options.relativePoint or "TOPLEFT",
        options.x or 0,
        options.y or 0
    )

    list:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3,
        },
    })

    list:SetBackdropColor(0, 0, 0, 0.65)

    list.visibleRows = options.visibleRows or 10
    list.rowHeight = options.rowHeight or 23
    list.rows = {}
    list.items = {}

    local index

    for index = 1, list.visibleRows do
        local row = CreateFrame("Button", nil, list)

        row:SetWidth((options.width or 260) - 18)
        row:SetHeight(list.rowHeight)

        row:SetPoint(
            "TOPLEFT",
            list,
            "TOPLEFT",
            7,
            -6 - ((index - 1) * list.rowHeight)
        )

        row.check = CreateFrame(
            "CheckButton",
            nil,
            row,
            "UICheckButtonTemplate"
        )

        row.check:SetWidth(20)
        row.check:SetHeight(20)
        row.check:SetPoint("LEFT", row, "LEFT", 0, 0)

        row.text = row:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlight"
        )

        row.text:SetPoint(
            "LEFT",
            row.check,
            "RIGHT",
            3,
            0
        )

        row.detail = row:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightSmall"
        )

        row.detail:SetPoint(
            "RIGHT",
            row,
            "RIGHT",
            -4,
            0
        )

        row.check.ownerRow = row

        row.check:SetScript("OnClick", function()
            local owner = this.ownerRow

            if owner and owner.item and options.onSelectionChanged then
                options.onSelectionChanged(
                    owner.item,
                    this:GetChecked() == 1
                )
            end
        end)

        row:SetScript("OnClick", function()
            if not this.item then
                return
            end

            local selected = not this.check:GetChecked()
            this.check:SetChecked(selected)

            if options.onSelectionChanged then
                options.onSelectionChanged(
                    this.item,
                    selected == 1 or selected == true
                )
            end
        end)

        row:SetScript("OnEnter", function()
            if not this.item then
                return
            end

            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:SetText(this.item.name or "Unknown")

            if options.tooltipText then
                GameTooltip:AddLine(
                    options.tooltipText,
                    0.3,
                    1.0,
                    0.3
                )
            end

            GameTooltip:Show()
        end)

        row:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        row:Hide()
        list.rows[index] = row
    end

    function list:SetItems(items)
        self.items = items or {}
        self:Refresh()
    end

    function list:Refresh()
        local rowIndex

        for rowIndex = 1, table.getn(self.rows) do
            local row = self.rows[rowIndex]
            local item = self.items[rowIndex]

            if item then
                row.item = item
                row.text:SetText(item.name or "Unknown")
                row.detail:SetText(item.class or "")

                local selected = false

                if options.isSelected then
                    selected = options.isSelected(item)
                end

                row.check:SetChecked(selected == true)

                local colours = AICraftBot.Constants.ClassColours
                local colour = nil

                if colours then
                    colour = colours[item.class] or colours.UNKNOWN
                end

                if colour then
                    row.text:SetTextColor(
                        colour[1],
                        colour[2],
                        colour[3]
                    )
                else
                    row.text:SetTextColor(1, 1, 1)
                end

                row:Show()
            else
                row.item = nil
                row.text:SetText("")
                row.detail:SetText("")
                row.check:SetChecked(false)
                row:Hide()
            end
        end
    end

    return list
end
