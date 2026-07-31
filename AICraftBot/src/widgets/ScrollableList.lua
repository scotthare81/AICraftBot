AICraftBot = AICraftBot or {}
AICraftBot.Widgets = AICraftBot.Widgets or {}

function AICraftBot.Widgets.CreateScrollableList(options)
    local list = {}

    list.parent = options.parent
    list.rows = {}
    list.data = {}
    list.visibleRows = options.visibleRows or 12
    list.rowHeight = options.rowHeight or 22
    list.selected = options.selected or {}
    list.onSelectionChanged = options.onSelectionChanged
    list.renderRow = options.renderRow

    list.frame = CreateFrame("Frame", nil, list.parent)
    list.frame:SetWidth(options.width or 220)
    list.frame:SetHeight(options.height or (list.visibleRows * list.rowHeight))
    list.frame:SetPoint(
        options.point or "TOPLEFT",
        options.relativeTo or list.parent,
        options.relativePoint or "TOPLEFT",
        options.x or 0,
        options.y or 0
    )

    function list:SetData(data)
        self.data = data or {}
        self:Refresh()
    end

    function list:SetSelected(selected)
        self.selected = selected or {}
        self:Refresh()
    end

    function list:GetSelected()
        return self.selected
    end

    function list:ClearSelection()
        self.selected = {}

        if self.onSelectionChanged then
            self.onSelectionChanged(self.selected)
        end

        self:Refresh()
    end

    function list:SelectAll(filter)
        local index

        for index = 1, table.getn(self.data) do
            local item = self.data[index]

            if not filter or filter(item) then
                local key = item.name or item.id or index
                self.selected[key] = true
            end
        end

        if self.onSelectionChanged then
            self.onSelectionChanged(self.selected)
        end

        self:Refresh()
    end

    function list:Refresh()
        if not self.renderRow then
            return
        end

        local index

        for index = 1, table.getn(self.rows) do
            self.renderRow(
                self.rows[index],
                self.data[index],
                index,
                self.selected
            )
        end
    end

    return list
end
