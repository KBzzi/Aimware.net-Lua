--KB's Semi Helper

local misc_ref = gui.Reference("Miscellaneous")
local misc_Movement_Group = gui.Reference("Miscellaneous", "Movement")
local KB_semiHelper_Group = gui.Groupbox(misc_ref, "[KB]Semi Helper", 17 +350 + 17, 300, 350, 0);

local ToggelAllWeaponAW = gui.Checkbox(KB_semiHelper_Group, "ToggelAllWeaponAW", "[KB]LegitAWallSwitch", false);
local drawToggelAllWeaponAWcolor = gui.ColorPicker(ToggelAllWeaponAW, "drawToggelAllWeaponAWcolor", "", 255, 0, 0, 255);
local drawToggelAllWeaponAWcolor2 = gui.ColorPicker(ToggelAllWeaponAW, "drawToggelAllWeaponAWcolor2", "", 255, 255, 255, 255);

local ToggelAllWeaponSM = gui.Checkbox(KB_semiHelper_Group, "ToggelAllWeaponSM", "[KB]LegitSmokeSwitch", false);
local drawToggelAllWeaponSMcolor = gui.ColorPicker(ToggelAllWeaponSM, "drawToggelAllWeaponSMcolor", "", 255, 0, 0, 255);
local drawToggelAllWeaponSMcolor2 = gui.ColorPicker(ToggelAllWeaponSM, "drawToggelAllWeaponSMcolor2", "", 255, 255, 255, 255);

local SwitchrBot = gui.Checkbox(KB_semiHelper_Group, "SwitchrBot", "[KB]Legit/ViolentSwitch", false);
local drawSwitchrBotcolor = gui.ColorPicker(SwitchrBot, "drawSwitchrBotcolor", "", 0, 255, 0, 255);
local drawSwitchrBotcolor2 = gui.ColorPicker(SwitchrBot, "drawSwitchrBotcolor2", "", 255, 255, 255, 255);

local ToggleTrgHitboxChange = gui.Checkbox(KB_semiHelper_Group, "ToggleTrgHitboxChange", "[KB]LegitTriggerMinDamage", false);
local drawToggleTrgHitboxChangecolor = gui.ColorPicker(ToggleTrgHitboxChange, "drawToggleTrgHitboxChangecolor", "", 0, 255, 0, 255);
local drawToggleTrgHitboxChangecolor2 = gui.ColorPicker(ToggleTrgHitboxChange, "drawToggleTrgHitboxChangecolor2", "", 255, 255, 255, 255);

local SafeTrgFly = gui.Checkbox(KB_semiHelper_Group, "SafeTrgFly", "[KB]LegitTriggerFly", false);

local weapongroup = {"shared","zeus","pistol","hpistol","smg","rifle","shotgun","scout","asniper","sniper","lmg"}

local tDrawCrosshairInfo = {}
local screenX, screenY = draw.GetScreenSize()
local DrawCrosshairInfofont = draw.CreateFont("Microsoft YaHei UI", 10, 150, false)

local tLastHitBoxValue = {}
local tCurrentHitBoxValue = {}



function getLocalPlayerAlive()
    local lp = entities.GetLocalPlayer()
    if lp == nil then
        return nil
    end
    if lp:IsAlive() ~= false then
        return lp
    end
    return nil
end

function getGuiColorPickerValue2Array(object)
    local r,g,b,a = object:GetValue()
    return {r=r,g=g,b=b,a=a}
end


function DrawColorText(x, y, text, color)
    draw.Color(color.r, color.g, color.b, color.a)
    draw.Text(x, y, text)
    draw.Color(255, 255, 255, 255)
end

function addtDrawCrosshairInfoStudent(id, name, value, color, color2)
    color = color or {r=255,g=0,b=0,a=255}
    color2 = color2 or {r=255,g=255,b=255,a=255}

    local item={}

    item.id=id
    item.name=name
    item.value=value
    item.color=color
    item.color2=color2

    tDrawCrosshairInfo[id]=item
end

function addHitBoxValueToStudent(id, name, value, state)
    value = value or "0 0 0 0 0 0 0 0"

    local item={}

    item.id=id
    item.name=name
    item.value=value
    
    if state ~= "last" then
        tLastHitBoxValue[id]=item
    end
    if state ~= "current" then
        tCurrentHitBoxValue[id]=item
    end
end

local lastAWState = nil
local lastSMState = nil
local lastrBotState = nil
local currentAWState = nil
local currentSMState = nil
local currentrBotState = nil
local lastTrgHitboxChangeState = nil
local currentTrgHitboxChangeState = nil
local lastAimbotState = gui.GetValue( "lbot.aim.enable" )
local currentAimbotState = nil

function drawCrosshairinfo()
    currentAWState = ToggelAllWeaponAW:GetValue()
    currentSMState = ToggelAllWeaponSM:GetValue()
    currentrBotState = SwitchrBot:GetValue()

    if lastAWState ~= currentAWState then
        lastAWState = currentAWState
        addtDrawCrosshairInfoStudent(1,"Auto Wall",lastAWState,getGuiColorPickerValue2Array(drawToggelAllWeaponAWcolor), getGuiColorPickerValue2Array(drawToggelAllWeaponAWcolor2))
        local value = currentAWState
        for i = 1, #weapongroup do
            gui.SetValue("lbot.weapon.vis." .. weapongroup[i] .. ".autowall", value)
        end
    end
    
    if lastSMState ~= currentSMState then
        lastSMState = currentSMState
        addtDrawCrosshairInfoStudent(2,"Through Smoke",lastSMState,getGuiColorPickerValue2Array(drawToggelAllWeaponSMcolor), getGuiColorPickerValue2Array(drawToggelAllWeaponSMcolor2))
        local value = currentSMState
        for i = 1, #weapongroup do
            gui.SetValue("lbot.weapon.vis." .. weapongroup[i] .. ".smoke", value)
        end
    end

    if lastrBotState ~= currentrBotState then
        lastrBotState = currentrBotState
        addtDrawCrosshairInfoStudent(4,"RAGE",lastrBotState,getGuiColorPickerValue2Array(drawSwitchrBotcolor), getGuiColorPickerValue2Array(drawSwitchrBotcolor2))
        if currentrBotState then
            gui.SetValue("rbot.master", 1)
            gui.SetValue("lbot.master", 0)
        else
            gui.SetValue("rbot.master", 0)
            gui.SetValue("lbot.master", 1)
        end
    end

    if gui.GetValue( "lbot.aim.enable" ) then
        addtDrawCrosshairInfoStudent(3,"Aimbot",true)
    else
        addtDrawCrosshairInfoStudent(3,"Aimbot",false)
    end

    
end

function LegitBotTrgHitboxChange()
    --get current hitbox value
    if #tCurrentHitBoxValue == 0 then
        for i = 1, #weapongroup do
            addHitBoxValueToStudent(i,weapongroup[i],gui.GetValue("lbot.trg.hitbox." .. weapongroup[i] .. ".hitbox"), "current")
        end
    end
    currentTrgHitboxChangeState = ToggleTrgHitboxChange:GetValue()
    

    --get last hitbox value
    if lastTrgHitboxChangeState ~= currentTrgHitboxChangeState then
        lastTrgHitboxChangeState = currentTrgHitboxChangeState
        addtDrawCrosshairInfoStudent(5,"TrgMinDmg",ToggleTrgHitboxChange:GetValue(),getGuiColorPickerValue2Array(drawToggleTrgHitboxChangecolor), getGuiColorPickerValue2Array(drawToggleTrgHitboxChangecolor2))
        for i = 1, #weapongroup do
            addHitBoxValueToStudent(i,weapongroup[i],gui.GetValue("lbot.trg.hitbox." .. weapongroup[i] .. ".hitbox"), "last")
            if tCurrentHitBoxValue[i].value ~= "1 1 1 1 1 1 1 1" and ToggleTrgHitboxChange:GetValue() == true then
                gui.SetValue("lbot.trg.hitbox." .. weapongroup[i] .. ".hitbox", "1 1 1 1 1 1 1 1")
            else
                gui.SetValue("lbot.trg.hitbox." .. weapongroup[i] .. ".hitbox", tLastHitBoxValue[i].value)   
            end
        end
        
    end

end

function doSafeTrgFly() 
    if SafeTrgFly:GetValue() then
        local lp = getLocalPlayerAlive()
        if lp == nil then return end 
        local isOnGround = lp:GetFieldBool("m_bOnGroundLastTick")
        currentAimbotState = gui.GetValue( "lbot.aim.enable" )
        if isOnGround then
            if wasInAir and lastAimbotState ~= nil then
                gui.SetValue("lbot.aim.enable", lastAimbotState)
            end
            lastAimbotState = currentAimbotState
            wasInAir = false
        else
            if not wasInAir then
                lastAimbotState = currentAimbotState
            end
            if currentAimbotState ~= false then
                gui.SetValue("lbot.aim.enable", false)
            end
            wasInAir = true
        end
    end
end

callbacks.Register("Draw", function()
    drawCrosshairinfo()
    LegitBotTrgHitboxChange()
    doSafeTrgFly()
    
    for i = 1, #tDrawCrosshairInfo do
        local info = tDrawCrosshairInfo[i]
        if info.value ~= nil then
            if info.value == true then
                local text = info.name
                draw.SetFont( DrawCrosshairInfofont )
                DrawColorText(screenX / 2, screenY / 2 + 10 + (i - 1) * 10, text, info.color)

            elseif info.value == false then
                local text = info.name
                draw.SetFont( DrawCrosshairInfofont )
                DrawColorText(screenX / 2, screenY / 2 + 10 + (i - 1) * 10, text, info.color2)

            end

        end
    end
end)
