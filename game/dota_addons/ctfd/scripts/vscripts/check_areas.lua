require('addon_game_mode')



function enterGoodArea(trigger)
  local unit = trigger.activator
  print("Enter Good")
  print(unit:GetUnitName())
  print(unit:GetTeamNumber())
  

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
--  unit:AddNewModifier(unit, nil, "modifier_magic_immune", {})
    unit:AddNewModifier(unit, nil, "modifier_attack_immune", {})
    local ModMaster = CreateItem("item_modifier_master", nil, nil) 
    ModMaster:ApplyDataDrivenModifier(unit, unit, "modifier_custom", nil)
    unit:AddNewModifier(unit, unit, "modifier_status_resistance", nil) --[[Returns:void
    No Description Set
    ]]
    --unit:AddNewModifier(unit, nil, "modifier_atta", {})
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" then
          --unit:RemoveModifierByName("modifier_magic_immune")
          unit:RemoveModifierByName("modifier_attack_immune")
          unit:RemoveModifierByName("modifier_custom") 
          unit:RemoveModifierByName('modifier_status_resistance')
        end
        --if item:GetAbilityName() == "item_capture_good_flag" then
         -- unit:RemoveItem(item)
         -- print("good guy drop their own flag")   
          --spawnGoodFlag()
        --end
      end
     end
  end
end


function enterBadArea(trigger)
  local unit = trigger.activator
  print("Enter Bad")
  print(unit:GetUnitName())
  print(unit:GetTeamNumber())
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    --unit:AddNewModifier(unit, nil, "modifier_magic_immune", {})
    unit:AddNewModifier(unit, nil, "modifier_attack_immune", {})
    local ModMaster = CreateItem("item_modifier_master", nil, nil) 
    ModMaster:ApplyDataDrivenModifier(unit, unit, "modifier_custom", nil)
    unit:AddNewModifier(unit, unit, "modifier_status_resistance", nil) 
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          --unit:RemoveModifierByName("modifier_magic_immune")
          unit:RemoveModifierByName("modifier_attack_immune")
          unit:RemoveModifierByName("modifier_custom") 
          unit:RemoveModifierByName('modifier_status_resistance')
        end
        --if item:GetAbilityName() == "item_capture_bad_flag" then
         -- unit:RemoveItem(item)
         -- print("bad guy drop their own flag")     
         -- spawnBadFlag()
        --end
      end
     end
  end
end


function leaveGoodArea(trigger)
  local unit = trigger.activator

--[[
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          unit:RemoveItem(item)
          spawnGoodFlag()
          print("good guy drop their own flag")
        end
      end
    end
  end
--]]

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
  --  unit:RemoveModifierByName("modifier_magic_immune")
    unit:RemoveModifierByName("modifier_attack_immune")
    unit:RemoveModifierByName("modifier_custom")           
    unit:RemoveModifierByName('modifier_status_resistance')
  end
end

function leaveBadArea(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
  --  unit:RemoveModifierByName("modifier_magic_immune")
    unit:RemoveModifierByName("modifier_attack_immune")
    unit:RemoveModifierByName("modifier_custom")           
    unit:RemoveModifierByName('modifier_status_resistance')
  end
end



--FORCE PLAYER TO DROP THEIR OWN FLAG 
--[[
function leaveGoodAreaBack(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          unit:RemoveItem(item)
          local ent = Entities:FindByName( nil, "point_teleport_jail_dire" ):GetAbsOrigin()
          FindClearSpaceForUnit(unit, ent, false)
          unit:Stop()
          spawnGoodFlag()
          print("good guy drop their own flag")
        end
      end
    end
  end
end


function leavBadAreaBack(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" then
          unit:RemoveItem(item)
          local ent = Entities:FindByName( nil, "point_teleport_jail_radiant" ):GetAbsOrigin()
          FindClearSpaceForUnit(unit, ent, false)
          unit:Stop()
          spawnBadFlag()
          print("bad guy drop their own flag")
        end
      end
    end
  end
end
--]]

--[[
function entergoodXPZone(trigger)

local hero = trigger.activator
if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then           
  
if _G.GAME_ROUND == 1 then
  hero:AddExperience(15, DOTA_ModifyXP_Unspecified, false, false)
end
if _G.GAME_ROUND == 2 then
   hero:AddExperience(25, DOTA_ModifyXP_Unspecified, false, false)
end
if _G.GAME_ROUND == 3 then
   hero:AddExperience(35, DOTA_ModifyXP_Unspecified, false, false)
end
            
            if _G.GAME_ROUND == 4 then
              hero:AddExperience(45, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 5 then
              hero:AddExperience(75, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 6 then
              hero:AddExperience(85, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 7 then
              hero:AddExperience(95, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 8 then
              hero:AddExperience(100, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 9 then
              hero:AddExperience(100, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 10 then
              hero:AddExperience(100, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 11 then
              hero:AddExperience(120, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 12 then
              hero:AddExperience(120, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 13 then
              hero:AddExperience(120, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 14 then
              hero:AddExperience(150, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 15 then
              hero:AddExperience(150, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 16 then
              hero:AddExperience(150, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 17 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 18 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 19 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 20 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
  print("enterXP")  
end
end

function enterbadXPZone(trigger)

local hero = trigger.activator
if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then           
  
if _G.GAME_ROUND == 1 then
  hero:AddExperience(35, DOTA_ModifyXP_Unspecified, false, false)
end
if _G.GAME_ROUND == 2 then
   hero:AddExperience(45, DOTA_ModifyXP_Unspecified, false, false)
end
if _G.GAME_ROUND == 3 then
   hero:AddExperience(55, DOTA_ModifyXP_Unspecified, false, false)
end
            
            if _G.GAME_ROUND == 4 then
              hero:AddExperience(65, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 5 then
              hero:AddExperience(75, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 6 then
              hero:AddExperience(85, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 7 then
              hero:AddExperience(95, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 8 then
              hero:AddExperience(100, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 9 then
              hero:AddExperience(100, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 10 then
              hero:AddExperience(100, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 11 then
              hero:AddExperience(120, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 12 then
              hero:AddExperience(120, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 13 then
              hero:AddExperience(120, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 14 then
              hero:AddExperience(150, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 15 then
              hero:AddExperience(150, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 16 then
              hero:AddExperience(150, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 17 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 18 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 19 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 20 then
              hero:AddExperience(200, DOTA_ModifyXP_Unspecified, false, false)
            end
  print("enterXP")  
end
end

--]]


--anti-camp

function enterantiGoodCamp(trigger)
local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:RemoveModifierByName("modifier_attack_immune")
    unit:RemoveModifierByName("modifier_custom")           
    unit:RemoveModifierByName('modifier_status_resistance')
  end
end

function leaveantiGoodCamp(trigger)
local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddNewModifier(unit, nil, "modifier_attack_immune", {})
    local ModMaster = CreateItem("item_modifier_master", nil, nil) 
    ModMaster:ApplyDataDrivenModifier(unit, unit, "modifier_custom", nil)
    unit:AddNewModifier(unit, unit, "modifier_status_resistance", nil)
	end
end


function enterantiBadCamp(trigger)
local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:RemoveModifierByName("modifier_attack_immune")
    unit:RemoveModifierByName("modifier_custom")           
    unit:RemoveModifierByName('modifier_status_resistance')
  end
end

function leaveantiBadCamp(trigger)
local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:AddNewModifier(unit, nil, "modifier_attack_immune", {})
    local ModMaster = CreateItem("item_modifier_master", nil, nil) 
    ModMaster:ApplyDataDrivenModifier(unit, unit, "modifier_custom", nil)
    unit:AddNewModifier(unit, unit, "modifier_status_resistance", nil)
	end
end



--REWARDS FOR RETURNING THE FLAG

function enterGoodAreaBack(trigger)
  local unit = trigger.activator
  if _G.BadHasFlag == 1 then
    print("g kill b first pls")
    GameRules:SendCustomMessage("<font color='#404040'>You Must Kill The Enemy Flag Holder Before Turning In a Flag</font>", DOTA_TEAM_NOTEAM, 0)
    return
  end
  

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" then
          unit:RemoveItem(item)
          spawnBadFlag()
          GameRules:SendCustomMessage("<font color='#b20000'> Good Guys Captured the Flag! </font>", DOTA_TEAM_NOTEAM, 0)
          pointGood()
          unit:IncrementDenies()
          reset()
          rewardGoodWin()
          unit:SetGold(unit:GetGold() + 100 + _G.GAME_ROUND * 10, false)        
        end
      end
    end    
  end
end



function enterBadAreaBack(trigger)
  local unit = trigger.activator
    if _G.GoodHasFlag == 1 then
    print("b kill g first pls")
    GameRules:SendCustomMessage("<font color='#404040'>You Must Kill The Enemy Flag Holder Before Turning In a Flag </font>", DOTA_TEAM_NOTEAM, 0)
    return
  end

  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          unit:RemoveItem(item)
          GameRules:SendCustomMessage("<font color='#ff0000'>Bad Guys Captured the Flag! </font>", DOTA_TEAM_NOTEAM, 0)
          pointBad()
          unit:IncrementDenies()
          spawnGoodFlag()
          reset()
          unit:SetGold(unit:GetGold() + 100 + _G.GAME_ROUND * 10 , false)
          rewardBadWin()
        end
      end
    end    
  end
end



function rewardBadWin()
    for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
      player = PlayerResource:GetPlayer(i)
      --print(player)
        if (player ~=nil) then
          hero = player:GetAssignedHero()
--          hero:HeroLevelUp(true)
          if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then             
            if _G.GAME_ROUND == 1 then
              hero:AddExperience(GAME_ROUND1experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 2 then
              hero:AddExperience(GAME_ROUND2experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 3 then
              hero:AddExperience(GAME_ROUND3experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 4 then
              hero:AddExperience(GAME_ROUND4experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 5 then
              hero:AddExperience(GAME_ROUND5experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 6 then
              hero:AddExperience(GAME_ROUND6experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 7 then
              hero:AddExperience(GAME_ROUND7experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 8 then
              hero:AddExperience(GAME_ROUND8experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 9 then
              hero:AddExperience(GAME_ROUND9experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 10 then
              hero:AddExperience(GAME_ROUND10experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 11 then
              hero:AddExperience(GAME_ROUND11experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 12 then
              hero:AddExperience(GAME_ROUND12experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 13 then
              hero:AddExperience(GAME_ROUND13experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 14 then
              hero:AddExperience(GAME_ROUND14experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 15 then
              hero:AddExperience(GAME_ROUND15experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 16 then
              hero:AddExperience(GAME_ROUND16experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 17 then
              hero:AddExperience(GAME_ROUND17experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 18 then
              hero:AddExperience(GAME_ROUND18experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 19 then
              hero:AddExperience(GAME_ROUND19experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 20 then
              hero:AddExperience(GAME_ROUND20experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
          end
          if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
            if _G.GAME_ROUND == 1 then
              hero:AddExperience(GAME_ROUND1experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 2 then
              hero:AddExperience(GAME_ROUND2experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 3 then
              hero:AddExperience(GAME_ROUND3experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 4 then
              hero:AddExperience(GAME_ROUND4experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 5 then
              hero:AddExperience(GAME_ROUND5experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 6 then
              hero:AddExperience(GAME_ROUND6experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 7 then
              hero:AddExperience(GAME_ROUND7experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 8 then
              hero:AddExperience(GAME_ROUND8experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 9 then
              hero:AddExperience(GAME_ROUND9experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 10 then
              hero:AddExperience(GAME_ROUND10experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 11 then
              hero:AddExperience(GAME_ROUND11experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 12 then
              hero:AddExperience(GAME_ROUND12experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 13 then
              hero:AddExperience(GAME_ROUND13experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 14 then
              hero:AddExperience(GAME_ROUND14experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 15 then
              hero:AddExperience(GAME_ROUND15experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 16 then
              hero:AddExperience(GAME_ROUND16experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 17 then
              hero:AddExperience(GAME_ROUND17experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 18 then
              hero:AddExperience(GAME_ROUND18experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 19 then
              hero:AddExperience(GAME_ROUND19experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 20 then
              hero:AddExperience(GAME_ROUND20experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
          end
        end
      end
    end

function rewardGoodWin()
    for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
      player = PlayerResource:GetPlayer(i)
      --print(player)
        if (player ~=nil) then
          hero = player:GetAssignedHero()
--          hero:HeroLevelUp(true)
          if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then             
            if _G.GAME_ROUND == 1 then
              hero:AddExperience(GAME_ROUND1experiencewin(), DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 2 then
              hero:AddExperience(GAME_ROUND2experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 3 then
              hero:AddExperience(GAME_ROUND3experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 4 then
              hero:AddExperience(GAME_ROUND4experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 5 then
              hero:AddExperience(GAME_ROUND5experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 6 then
              hero:AddExperience(GAME_ROUND6experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 7 then
              hero:AddExperience(GAME_ROUND7experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 8 then
              hero:AddExperience(GAME_ROUND8experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 9 then
              hero:AddExperience(GAME_ROUND9experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 10 then
              hero:AddExperience(GAME_ROUND10experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 11 then
              hero:AddExperience(GAME_ROUND11experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 12 then
              hero:AddExperience(GAME_ROUND12experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 13 then
              hero:AddExperience(GAME_ROUND13experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 14 then
              hero:AddExperience(GAME_ROUND14experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 15 then
              hero:AddExperience(GAME_ROUND15experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 16 then
              hero:AddExperience(GAME_ROUND16experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 17 then
              hero:AddExperience(GAME_ROUND17experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 18 then
              hero:AddExperience(GAME_ROUND18experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 19 then
              hero:AddExperience(GAME_ROUND19experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 20 then
              hero:AddExperience(GAME_ROUND20experiencewin, DOTA_ModifyXP_Unspecified, false, false)
            end
          end
          if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
            if _G.GAME_ROUND == 1 then
              hero:AddExperience(GAME_ROUND1experiencelose(), DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 2 then
              hero:AddExperience(GAME_ROUND2experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 3 then
              hero:AddExperience(GAME_ROUND3experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 4 then
              hero:AddExperience(GAME_ROUND4experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 5 then
              hero:AddExperience(GAME_ROUND5experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 6 then
              hero:AddExperience(GAME_ROUND6experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 7 then
              hero:AddExperience(GAME_ROUND7experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 8 then
              hero:AddExperience(GAME_ROUND8experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 9 then
              hero:AddExperience(GAME_ROUND9experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 10 then
              hero:AddExperience(GAME_ROUND10experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 11 then
              hero:AddExperience(GAME_ROUND11experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 12 then
              hero:AddExperience(GAME_ROUND12experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 13 then
              hero:AddExperience(GAME_ROUND13experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 14 then
              hero:AddExperience(GAME_ROUND14experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 15 then
              hero:AddExperience(GAME_ROUND15experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 16 then
              hero:AddExperience(GAME_ROUND16experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 17 then
              hero:AddExperience(GAME_ROUND17experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 18 then
              hero:AddExperience(GAME_ROUND18experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 19 then
              hero:AddExperience(GAME_ROUND19experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
            if _G.GAME_ROUND == 20 then
              hero:AddExperience(GAME_ROUND20experiencelose, DOTA_ModifyXP_Unspecified, false, false)
            end
          end
        end
      end
    end







  
