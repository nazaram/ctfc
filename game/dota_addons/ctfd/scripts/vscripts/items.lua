require('addon_game_mode')


function pickOrReturnGoodFlag(event)
  local unit = EntIndexToHScript(event.caster_entindex)
  CustomGameEventManager:Send_ServerToAllClients( "Good Flag Taken", {})
  print("Good Flag Taken")
  print(unit:GetUnitName())
  
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    print('Bad Guys Took Good Flag')
    GameRules:SendCustomMessage("<font color='#ff4c4c'>BAD GUYS TOOK THE FLAG!!!</font>", DOTA_TEAM_NOTEAM, 0)
    EmitGlobalSound("tutorial_rockslide")
    _G.BadHasFlag = 1
    
    local WhoHasFlag = 
    {
    GoodHasFlag = _G.GoodHasFlag, 
    BadHasFlag = _G.BadHasFlag 
    }
    CustomGameEventManager:Send_ServerToAllClients( "has_flag", WhoHasFlag )
  end
  
  --[[
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    print("Good Guy took Good Flag")
    GameRules:SendCustomMessage("good guys took their own flag. pls dont. good players who pick up their own flag again will go to jail", DOTA_TEAM_NOTEAM, 0)
    for i = 0,5 do
      print("i:"..i)
      local item = unit:GetItemInSlot(i)
      if item then
        print("item:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_good_flag" then
          unit:RemoveItem(item)
          spawnGoodFlag()
          print("good guy drop their own flag")
        end
      end
    end
  end
--]]


end

function pickOrReturnBadFlag(event)
  local unit = EntIndexToHScript(event.caster_entindex)
  print("Bad Flag Taken")
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    GameRules:SendCustomMessage("<font color='#66b266'>GOOD GUYS TOOK THE FLAG!!!</font>", DOTA_TEAM_NOTEAM, 0)    
    print('Good Guys Took Good Flag')
    EmitGlobalSound( "Hero_Invoker.SunStrike.Ignite" )
    _G.GoodHasFlag = 1
    local WhoHasFlag = 
    {
    GoodHasFlag = _G.GoodHasFlag, 
    BadHasFlag = _G.BadHasFlag 
    } 

    
    CustomGameEventManager:Send_ServerToAllClients("has_flag", WhoHasFlag )

  end
  EmitGlobalSound("compendium_levelup")
  print(unit:GetUnitName())
  --[[
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    print("Bad Guy took Bad Flag")
    GameRules:SendCustomMessage("bad guys took their own flag. pls dont. bad players who pick up their own flag again will go to jail", DOTA_TEAM_NOTEAM, 0)
    for i = 0,5 do
      print("i:"..i)
      local item = unit:GetItemInSlot(i)
      if item then
        print("item nome:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_bad_flag" then
         unit:RemoveItem(item)
          print("Bad Guy Drop Bad Flag")
          spawnBadFlag()
        end
      end
    end
  end
  --]]
end



function bountypickup(event)
    local unit = EntIndexToHScript(event.caster_entindex)
    print(unit)
   unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
    --attacker:AddExperience(hero:GetCurrentXP() + 100, DOTA_ModifyXP_Unspecified, false, false)
    unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
end


function OnPlayerPickupCoinA(keys)
  local caster = keys.caster
  local unit = EntIndexToHScript(keys.caster_entindex)
  local bountyrune1 = CreateItem("item_bounty_rune_A", nil, nil) 

  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
    unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
    UTIL_RemoveImmediate(keys.ability)
    EmitSoundOn("General.Coins",caster)
    _G.BountyPickedGood = 1
  end

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    UTIL_RemoveImmediate(keys.ability)
    CreateItemOnPositionSync(Vector(-1845.27, 2667.82, 472.407), bountyrune1)
  end
end




function OnPlayerPickupCoinB(keys)
  local caster = keys.caster
  local unit = EntIndexToHScript(keys.caster_entindex)
  local bountyrune2 = CreateItem("item_bounty_rune_B", nil, nil)  

  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
    unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
    UTIL_RemoveImmediate(keys.ability)
    EmitSoundOn("General.Coins",caster)
    _G.BountyPickedGood = 1
  end

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    UTIL_RemoveImmediate(keys.ability)
    CreateItemOnPositionSync(Vector(-3430.15, 3198.03, 331.071), bountyrune2)
  end
end


function OnPlayerPickupCoinC(keys)
  local caster = keys.caster
  local unit = EntIndexToHScript(keys.caster_entindex)
  local bountyrune3 = CreateItem("item_bounty_rune_C", nil, nil)  

  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
    unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
    UTIL_RemoveImmediate(keys.ability)
    EmitSoundOn("General.Coins",caster)
    _G.BountyPickedGood = 1
  end

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    UTIL_RemoveImmediate(keys.ability)
    CreateItemOnPositionSync(Vector(-1993.54, -653.823, 438.064), bountyrune3)
  end
  
end


function OnPlayerPickupCoinD(keys)
  local caster = keys.caster
  local unit = EntIndexToHScript(keys.caster_entindex)
  local bountyrune4 = CreateItem("item_bounty_rune_D", nil, nil)  

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
  unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
  unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
  UTIL_RemoveImmediate(keys.ability)
  EmitSoundOn("General.Coins",caster)
  _G.BountyPickedBad = 1
  end

  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    UTIL_RemoveImmediate(keys.ability)
    CreateItemOnPositionSync(Vector(2499.64, 2673.39, 427.251), bountyrune4)
  end
end



function OnPlayerPickupCoinE(keys)
  local caster = keys.caster
  local unit = EntIndexToHScript(keys.caster_entindex)
  local bountyrune5 = CreateItem("item_bounty_rune_E", nil, nil)  

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
  unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
    unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
  UTIL_RemoveImmediate(keys.ability)
  EmitSoundOn("General.Coins",caster)
   _G.BountyPickedBad = 1
  end
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    UTIL_RemoveImmediate(keys.ability)
    CreateItemOnPositionSync(Vector(4099.58, 3192.45, 342.538), bountyrune5)
  end
end



function OnPlayerPickupCoinF(keys)
  local caster = keys.caster
  local unit = EntIndexToHScript(keys.caster_entindex)
  local bountyrune6 = CreateItem("item_bounty_rune_F", nil, nil)  

  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
  unit:AddExperience(25 + _G.GAME_ROUND * 5 , DOTA_ModifyXP_Unspecified, false, false)
  unit:SetGold(unit:GetGold() + 50 + _G.GAME_ROUND * 5, false)
  UTIL_RemoveImmediate(keys.ability)
  EmitSoundOn("General.Coins",caster)
  _G.BountyPickedBad = 1
  end

  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    UTIL_RemoveImmediate(keys.ability)
    CreateItemOnPositionSync(Vector(2618.97, -678.654, 440.487), bountyrune6)
  end
end


function OnAssignAbilityTimberChain(keys)
  local caster = keys.caster
  print(caster)
  local hero = EntIndexToHScript(keys.caster_entindex)
  print("in function OnAssignAbilityTimberChain")
  print(hero)
  if hero:IsRealHero() and hero:HasAbility("barebones_empty1") then
    print("true")
    hero:RemoveAbility("barebones_empty1")
    hero:AddAbility("shredder_chain"):SetLevel(1)
    --hero:SwapAbilities("barebones_empty1", "shredder_chain", true, false)
  elseif hero:IsRealHero() and hero:HasAbility("barebones_empty2") then
    print("true")
    hero:RemoveAbility("barebones_empty2")
    hero:AddAbility("shredder_chain"):SetLevel(1)
    --hero:SwapAbilities("barebones_empty1", "shredder_chain", true, false)
  end
  end

function OnAssignArmourUp(keys)
  local caster = keys.caster
  print(caster)
  local hero = EntIndexToHScript(keys.caster_entindex)
  print("in function OnAssignAbilityArmorUp")
  print(hero)
  if hero:IsRealHero() and hero:HasAbility("barebones_empty1") then
    print("true")
    hero:RemoveAbility("barebones_empty1")
    hero:AddAbility("Armour_Up"):SetLevel(1)
    --hero:SwapAbilities("barebones_empty1", "shredder_chain", true, false)
  elseif hero:IsRealHero() and hero:HasAbility("barebones_empty2") then
    print("true")
    hero:RemoveAbility("barebones_empty2")
    hero:AddAbility("Armour_Up"):SetLevel(1)
    --hero:SwapAbilities("barebones_empty1", "shredder_chain", true, false)
  end
  end


--[[
  if hero:IsHero() then
    print("inhero")
    local old_ability_0 = hero:GetAbilityByIndex(0)
    local old_ability_1 = hero:GetAbilityByIndex(1)
    if old_ability_0 == "barebones_empty1" then 
      print("potato")
      hero:GetAbilityByIndex(0) = "shredder_chain"
      hero:SetAbilityPoints(1)
      hero = hero:FindAbilityByName("shredder_chain")
      chain:SetLevel(1) 
      chain:SetActivated(true)
    end
  end
end


  local innateAbilityName16 = "tusk_frozen_sigil"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName16) then
    entity:FindAbilityByName(innateAbilityName16):SetLevel(1)
   end

--]]