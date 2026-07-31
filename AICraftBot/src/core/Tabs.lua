AICraftBot = AICraftBot or {}
AICraftBot.Tabs = AICraftBot.Tabs or {}

local tabs = {}

function AICraftBot.Tabs.Register(name, frame)
    if not name or not frame then
        return
    end

    tabs[name] = frame
end

function AICraftBot.Tabs.Show(name)
    local tabName
    local tabFrame

    for tabName, tabFrame in pairs(tabs) do
        if tabFrame then
            tabFrame:Hide()
        end
    end

    if tabs[name] then
        tabs[name]:Show()
    end
end

function AICraftBot.Tabs.Get(name)
    return tabs[name]
end

function AICraftBot.Tabs.CreatePanel(parent, name, titleText)
    local frame = CreateFrame("Frame", nil, parent)

    frame:SetAllPoints(parent)
    frame:Hide()

    local title = frame:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalLarge"
    )

    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -20)
    title:SetText(titleText or name)

    frame.title = title
    frame.tabName = name

    if name ~= "Dashboard" then
        local backButton = CreateFrame(
            "Button",
            nil,
            frame,
            "UIPanelButtonTemplate"
        )

        backButton:SetWidth(90)
        backButton:SetHeight(24)
        backButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -16)
        backButton:SetText("Back")

        backButton:SetScript("OnClick", function()
            AICraftBot.Tabs.Show("Dashboard")
        end)

        AICraftBot.UI.SetTooltip(
            backButton,
            "Back",
            "Returns to the Dashboard."
        )

        frame.backButton = backButton
    end

    AICraftBot.Tabs.Register(name, frame)

    return frame
end

function AICraftBot.Tabs.GetAll()
    return tabs
end
