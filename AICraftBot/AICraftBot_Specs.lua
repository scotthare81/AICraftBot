AICraftBot=AICraftBot or {}

AICraftBotSpecs={}

AICraftBotSpecs.SpecsByClass={
    WARRIOR={
        {name="Protection",command="pve prot"},
        {name="Fury",command="pve fury"},
        {name="Arms",command="pve arms"}
    },

    PALADIN={
        {name="Holy",command="pve heal holy (sanctuary)"},
        {name="Protection",command="pvp tank prot"},
        {name="Retribution",command="pve dps ret (geared ret)"}
    },

    HUNTER={
        {name="Beast Mastery",command="pve dps bm (farmer)"},
        {name="Marksmanship",command="pve dps mm"},
        {name="Survival",command="pvp dps surv"}
    },

    ROGUE={
        {name="Assassination",command="pve dps assasination"},
        {name="Combat",command="pve dps combat (swords)"},
        {name="Subtlety",command="pvp dps combat"}
    },

    PRIEST={
        {name="Discipline",command="pve heal disc"},
        {name="Holy",command="pve heal holy"},
        {name="Shadow",command="pve dps shadow"}
    },

    SHAMAN={
        {name="Elemental",command="pve dps elem (elemental mastery)"},
        {name="Enhancement",command="pvp dps enhan (2hand)"},
        {name="Restoration",command="pve heal resto (pure)"}
    },

    MAGE={
        {name="Arcane",command="pve dps arcane"},
        {name="Fire",command="pve dps fire"},
        {name="Frost",command="pve dps frost"}
    },

    WARLOCK={
        {name="Affliction",command="pve dps affli"},
        {name="Demonology",command="pve dps demo (succubus sacrifice)"},
        {name="Destruction",command="pve dps dest (imp lord)"}
    },

    DRUID={
        {name="Balance",command="pvp dps balance (boomkin)"},
        {name="Feral Tank",command="pve dps feral"},
        {name="Feral DPS",command="pve dps feral (dps/tank hybrid)"},
        {name="Restoration",command="pve dps resto (swiftmend spec)"}
    }
}

AICraftBotSpecs.IndexByClass={}

function AICraftBotSpecs:GetSelectedClass()
    if not AICraftBot.Legacy then
        return nil,"No Bots Selected"
    end

    local selected=AICraftBot.Legacy.GetSelectedActiveBots()
    local roster=AICraftBot.Legacy.GetActiveRoster()
    local selectedClass=nil
    local selectedCount=0

    for i=1,table.getn(roster) do
        local bot=roster[i]

        if selected[bot.name] then
            selectedCount=selectedCount+1

            if not selectedClass then
                selectedClass=string.upper(bot.class or "UNKNOWN")
            elseif selectedClass~=string.upper(bot.class or "UNKNOWN") then
                return nil,"Multiple Classes Selected"
            end
        end
    end

    if selectedCount==0 then
        return nil,"No Bots Selected"
    end

    if not self.SpecsByClass[selectedClass] then
        return nil,"Unsupported Class"
    end

    return selectedClass,nil
end

function AICraftBotSpecs:GetIndex(class)
    local index=self.IndexByClass[class] or 1
    local specs=self.SpecsByClass[class]

    if index>table.getn(specs) then
        index=1
    end

    self.IndexByClass[class]=index
    return index
end

function AICraftBotSpecs:Get()
    local class,errorText=self:GetSelectedClass()

    if not class then
        return errorText,nil,nil
    end

    local index=self:GetIndex(class)
    local spec=self.SpecsByClass[class][index]

    return spec.name,spec.command,class
end

function AICraftBotSpecs:Next()
    local class=self:GetSelectedClass()

    if not class then
        return
    end

    local specs=self.SpecsByClass[class]
    local index=self:GetIndex(class)+1

    if index>table.getn(specs) then
        index=1
    end

    self.IndexByClass[class]=index
end

function AICraftBotSpecs:Prev()
    local class=self:GetSelectedClass()

    if not class then
        return
    end

    local specs=self.SpecsByClass[class]
    local index=self:GetIndex(class)-1

    if index<1 then
        index=table.getn(specs)
    end

    self.IndexByClass[class]=index
end
