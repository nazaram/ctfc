require('effect_modifiers')



function OnEndTouch(trigger)

  print(trigger.activator)
  print(trigger.caller)
end


function JailTriggeredDire(trigger)
  print("YAY")
    
--[[    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      -- Get the position of the "point_teleport_spot"-entity we put in our map
      local point =  Entities:FindByName( nil, "point_teleport_spot2" ):GetAbsOrigin()
      -- Find a spot for the hero around 'point' and teleports to it
      FindClearSpaceForUnit(trigger.activator, point, false)
      -- Stop the hero, so he doesn't move
      trigger.activator:Stop()
      -- Refocus the camera of said player to the position of the teleported hero.
      SendToConsole("dota_camera_center")
      --local v = point
--v.x = v.x + RandomInt(0,5)
--v.y = v.y + RandomInt(0,5)

    end
 
--]]
  end

function JailTriggeredDire2(trigger)
  print(trigger.activator)
  print(trigger.caller)
end


-- when good enters bad jail  
function JailMuteDire(trigger)
    print("YAY1")
    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
     
      local caster = trigger.activator
      local old_ability_0 = caster:GetAbilityByIndex(0)
      local old_ability_1 = caster:GetAbilityByIndex(1)
      local old_ability_2 = caster:GetAbilityByIndex(2)
      local old_ability_3 = caster:GetAbilityByIndex(3)
      local old_ability_4 = caster:GetAbilityByIndex(4)
      local old_ability_5 = caster:GetAbilityByIndex(5)
      local old_ability_6 = caster:GetAbilityByIndex(6)
      old_ability_0:SetActivated(false)
      old_ability_1:SetActivated(false)
      old_ability_2:SetActivated(true)
      old_ability_3:SetActivated(false)
      old_ability_5:SetActivated(false)
      old_ability_4:SetActivated(false)

if trigger.activator:GetItemInSlot(0) ~= nil then
      	local item0 = trigger.activator:GetItemInSlot(0)
      	item0:SetActivated(false)
 	 end
 	if trigger.activator:GetItemInSlot(1) ~= nil then
      	local item1 = trigger.activator:GetItemInSlot(1)
      	 item1:SetActivated(false)
  	 end

  	if trigger.activator:GetItemInSlot(2) ~= nil then
  		local item2 = trigger.activator:GetItemInSlot(2)
  		      item2:SetActivated(false)
    end
    
    if trigger.activator:GetItemInSlot(3) ~= nil then
    	local item3 = trigger.activator:GetItemInSlot(3)
    	      item3:SetActivated(false)
    end
    if trigger.activator:GetItemInSlot(4) ~= nil then
      local item4 = trigger.activator:GetItemInSlot(4)
            item4:SetActivated(false)
    end

    if trigger.activator:GetItemInSlot(5) ~= nil then
      local item5 = trigger.activator:GetItemInSlot(5)
            item5:SetActivated(false)
    end

    if trigger.activator:GetItemInSlot(6) ~= nil then
     local item6 = trigger.activator:GetItemInSlot(6)
           item6:SetActivated(false)
    end










      trigger.activator:AddNewModifier(nil, nil, "modifier_stunned", {duration = 0.1})
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_invulnerable", nil)
      --trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_silence", nil)
      giveUnitDataDrivenModifier(trigger.activator, trigger.activator, "modifier_make_muted", nil)
      --giveUnitDataDrivenModifier(trigger.activator, trigger.activator, "modifier_make_muted", nil) -- "-1" means that it will last forever (or until its removed)
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_disarmed", nil)
      _G.GoodinPrison = _G.GoodinPrison + 1
      print("Good Joined Prison. Prison Count is")
      print (_G.GoodinPrison)
      if _G.GoodinPrison == _G.GoodPlayers then
        GameRules:SendCustomMessage("<font color='#ff0000'>All Good Players Have Been Jailed!</font>", DOTA_TEAM_NOTEAM, 0)
        pointBad()
        reset()
        _G.GoodinPrison = 0
        _G.BadinPrison = 0  
     end
   end
  end


--when good leaves bad jail 
function JailMuteDire2(trigger)
      
      local caster = trigger.activator
      local old_ability_0 = caster:GetAbilityByIndex(0)
      local old_ability_1 = caster:GetAbilityByIndex(1)
      local old_ability_2 = caster:GetAbilityByIndex(2)
      local old_ability_3 = caster:GetAbilityByIndex(3)
      local old_ability_4 = caster:GetAbilityByIndex(4)
      local old_ability_5 = caster:GetAbilityByIndex(5)
      old_ability_0:SetActivated(true)
      old_ability_1:SetActivated(true)
      old_ability_2:SetActivated(false)
      old_ability_3:SetActivated(true)
      old_ability_4:SetActivated(true)
      old_ability_5:SetActivated(true)
      caster:FindAbilityByName("torrent_datadriven"):SetActivated(false)


    if trigger.activator:GetItemInSlot(0) ~= nil then
      	local item0 = trigger.activator:GetItemInSlot(0)
      	item0:SetActivated(true)
 	 end
 	if trigger.activator:GetItemInSlot(1) ~= nil then
      	local item1 = trigger.activator:GetItemInSlot(1)
      	 item1:SetActivated(true)
  	 end

  	if trigger.activator:GetItemInSlot(2) ~= nil then
  		local item2 = trigger.activator:GetItemInSlot(2)
  		      item2:SetActivated(true)
    end
    
    if trigger.activator:GetItemInSlot(3) ~= nil then
    	local item3 = trigger.activator:GetItemInSlot(3)
    	      item3:SetActivated(true)
    end
    if trigger.activator:GetItemInSlot(4) ~= nil then
      local item4 = trigger.activator:GetItemInSlot(4)
            item4:SetActivated(true)
    end

    if trigger.activator:GetItemInSlot(5) ~= nil then
      local item5 = trigger.activator:GetItemInSlot(5)
            item5:SetActivated(true)
    end

    if trigger.activator:GetItemInSlot(6) ~= nil then
     local item6 = trigger.activator:GetItemInSlot(6)
           item6:SetActivated(true)
    end



    if _G.GoodinPrison < 0 then 
        _G.GoodinPrison = 0 
    end
    print(trigger.activator)
    print(trigger.caller)
    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      trigger.activator:RemoveModifierByName("modifier_invulnerable")
      --trigger.activator:RemoveModifierByName("modifier_silence")
      trigger.activator:RemoveModifierByName("modifier_disarmed")
      trigger.activator:RemoveModifierByName("modifier_make_muted")
      _G.GoodinPrison = _G.GoodinPrison - 1
      if _G.GoodinPrison < 0 then 
        _G.GoodinPrison = 0 
      end
      print("Good Left Prison. Prison Count is:")
      print (_G.GoodinPrison)
   end
end

function JailMuteRadiant(trigger)
    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then    
      local caster = trigger.activator
      local old_ability_0 = caster:GetAbilityByIndex(0)
      local old_ability_1 = caster:GetAbilityByIndex(1)
      local old_ability_2 = caster:GetAbilityByIndex(2)
      local old_ability_3 = caster:GetAbilityByIndex(3)
      local old_ability_4 = caster:GetAbilityByIndex(4)
      local old_ability_5 = caster:GetAbilityByIndex(5)
      local old_ability_6 = caster:GetAbilityByIndex(6)
      old_ability_0:SetActivated(false)
      old_ability_1:SetActivated(false)
      old_ability_2:SetActivated(true)
      old_ability_3:SetActivated(false)
      old_ability_5:SetActivated(false)
      old_ability_4:SetActivated(false)

    if trigger.activator:GetItemInSlot(0) ~= nil then
      	local item0 = trigger.activator:GetItemInSlot(0)
      	item0:SetActivated(false)
 	 end
 	if trigger.activator:GetItemInSlot(1) ~= nil then
      	local item1 = trigger.activator:GetItemInSlot(1)
      	 item1:SetActivated(false)
  	 end

  	if trigger.activator:GetItemInSlot(2) ~= nil then
  		local item2 = trigger.activator:GetItemInSlot(2)
  		      item2:SetActivated(false)
    end
    
    if trigger.activator:GetItemInSlot(3) ~= nil then
    	local item3 = trigger.activator:GetItemInSlot(3)
    	      item3:SetActivated(false)
    end
    if trigger.activator:GetItemInSlot(4) ~= nil then
      local item4 = trigger.activator:GetItemInSlot(4)
            item4:SetActivated(false)
    end

    if trigger.activator:GetItemInSlot(5) ~= nil then
      local item5 = trigger.activator:GetItemInSlot(5)
            item5:SetActivated(false)
    end

    if trigger.activator:GetItemInSlot(6) ~= nil then
     local item6 = trigger.activator:GetItemInSlot(6)
           item6:SetActivated(false)
    end



      trigger.activator:AddNewModifier(nil, nil, "modifier_stunned", {duration = 0.1})
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_invulnerable", nil)
      trigger.activator:AddNewModifier(nil, nil, "modifier_muted", {duration = 5})

     -- trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_silence", nil)
      --giveUnitDataDrivenModifier(trigger.activator, trigger.activator, "modifier_make_muted", nil)
      trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_disarmed", nil)
      _G.BadinPrison = _G.BadinPrison + 1
      print("Bad Joined Prison. Prison Count is")
      print (_G.BadinPrison)
      if _G.BadinPrison == _G.BadPlayers then
        GameRules:SendCustomMessage("<font color='#b20000'> All Bad Players Have Been Jailed! </font>", DOTA_TEAM_NOTEAM, 0)
        pointGood()
        reset()
        _G.GoodinPrison = 0
        _G.BadinPrison = 0  
      end
    end
  end


function RemoveAllAbility (caster)
  local abilityList = {}
  for i=0,5 do
    if caster:GetAbilityByIndex(i) ~= nil then 
      local abil = caster:GetAbilityByIndex(i):GetName()
      abilityList[i+1] = abil
      caster:RemoveAbility(caster:GetAbilityByIndex(i):GetName())
    else 
      break
    end
  end
  caster.SavedList = abilityList
end

function RestoreAllAbility(caster)
  for i=0, 5 do
    if caster.SavedList[i] == nil then break
    else
      caster:AddAbility(caster.SavedList[i])
    end
    LevelAllAbility(caster)
  end
end


function JailMuteRadiant2(trigger)
    print(trigger.activator)
    print(trigger.caller)
    if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
      local caster = trigger.activator
      local old_ability_0 = caster:GetAbilityByIndex(0)
      local old_ability_1 = caster:GetAbilityByIndex(1)
      local old_ability_2 = caster:GetAbilityByIndex(2)
      local old_ability_3 = caster:GetAbilityByIndex(3)
      local old_ability_4 = caster:GetAbilityByIndex(4)
      local old_ability_5 = caster:GetAbilityByIndex(5)
      old_ability_0:SetActivated(true)
      old_ability_1:SetActivated(true)
      old_ability_2:SetActivated(false)
      old_ability_3:SetActivated(true)
      old_ability_5:SetActivated(true)

    if trigger.activator:GetItemInSlot(0) ~= nil then
      	local item0 = trigger.activator:GetItemInSlot(0)
      	item0:SetActivated(true)
 	 end
 	if trigger.activator:GetItemInSlot(1) ~= nil then
      	local item1 = trigger.activator:GetItemInSlot(1)
      	 item1:SetActivated(true)
  	 end

  	if trigger.activator:GetItemInSlot(2) ~= nil then
  		local item2 = trigger.activator:GetItemInSlot(2)
  		      item2:SetActivated(true)
    end
    
    if trigger.activator:GetItemInSlot(3) ~= nil then
    	local item3 = trigger.activator:GetItemInSlot(3)
    	      item3:SetActivated(true)
    end
    if trigger.activator:GetItemInSlot(4) ~= nil then
      local item4 = trigger.activator:GetItemInSlot(4)
            item4:SetActivated(true)
    end

    if trigger.activator:GetItemInSlot(5) ~= nil then
      local item5 = trigger.activator:GetItemInSlot(5)
            item5:SetActivated(true)
    end

    if trigger.activator:GetItemInSlot(6) ~= nil then
     local item6 = trigger.activator:GetItemInSlot(6)
           item6:SetActivated(true)
    end



      caster:FindAbilityByName("torrent_datadriven"):SetActivated(false)
      
      trigger.activator:RemoveModifierByName("modifier_invulnerable")
      --trigger.activator:RemoveModifierByName("modifier_silence")
      trigger.activator:RemoveModifierByName("modifier_disarmed")
      trigger.activator:RemoveModifierByName("modifier_make_muted")
      _G.BadinPrison = _G.BadinPrison - 1
    end
    if _G.BadinPrison < 0 then 
        _G.BadinPrison = 0 
    end
    print("Good Left Prison. Prison Count is:")
    print (_G.BadinPrison)
end


  
function GiveFlask (hero)
    if hero:HasRoomForItem("item_flask", true, true) then
       local flask = CreateItem("item_flask", hero, hero)
       flask:SetPurchaseTime(0)
       hero:AddItem(flask)
    end
 end

function OnStartTouch(trigger)
  print("testjail1")
  GiveFlask(hero)
  print(trigger.activator)
  print(trigger.caller)
  
end








--[[function spawn(keys)
  local inTrigger = false
  local CHECKINGRADIUS = 10

    for _,thing in pairs(Entities:FindAllInSphere(GetGroundPosition(keys.target_points[1], nil), CHECKINGRADIUS) )  do

        if (thing:GetName() == "jail_box") then
            --In no_ward trigger. Set flag.
            inTrigger = true
        end

    end
    
    if (inTrigger == True)
       --Used onto specified area. Do stuff...
       print("in JAIL")
    end
end
--]]


function Teleport(trigger)
  if _G.Button == 1 then
  print("teleport good")
  --local point1 = Entities:FindByName( nil, "point_teleport_bad" ):GetAbsOrigin()
  --local point2 = Entities:FindByName(Vector(2460.57, 10036.4, 296.238)):GetAbsOrigin()
  FindClearSpaceForUnit(trigger.activator, Vector(324.671, 3515.67, 291.372), false)
  trigger.activator:Stop()
  FindClearSpaceForUnit(trigger.activator, Vector(1857.42, 3677.31, 291.372), false)
  trigger.activator:Stop()
  FindClearSpaceForUnit(trigger.activator, Vector(3786.06, 2658.56, 291.372), false)
  trigger.activator:Stop()
  SendToConsole("dota_camera_center")
  end
 if _G.Button == 2 then
  print("teleport bad")
  FindClearSpaceForUnit(trigger.activator, Vector(324.671, 3515.67, 291.372), false)
  trigger.activator:Stop()
  local point1 = Entities:FindByName( nil, "point_teleport_good" ):GetAbsOrigin()
  FindClearSpaceForUnit(trigger.activator, point1, false)
    trigger.activator:Stop()
    SendToConsole("dota_camera_center")
 end
end

function Teleport_Bad(trigger)
    print("teleport_bad")
  if _G.Button == 1 then

  FindClearSpaceForUnit(trigger.activator, Vector(2760.5, 3677.31, 291.372), false)
  trigger.activator:Stop()
  FindClearSpaceForUnit(trigger.activator, Vector(1857.42, 3677.31, 291.372), false)
  trigger.activator:Stop()
  FindClearSpaceForUnit(trigger.activator, Vector(330.671, 3515.67, 291.372), false)
  trigger.activator:Stop()
  SendToConsole("dota_camera_center")
  end
end

function Teleport_Good(trigger)
   print("teleport_good1")
  if _G.Button == 2 then
    print("teleport_good")
    FindClearSpaceForUnit(trigger.activator, Vector(330.671, 3515.67, 291.372), false)
    trigger.activator:Stop()  
    SendToConsole("dota_camera_center")
  end
end


 function ButtonPress(trigger)
  print("button press")
  print(trigger.activator)
  _G.Button =  _G.Button + 1
  if _G.Button == 3 then
    _G.Button = 1
  end
end


function reset_force(trigger)
EmitGlobalSound("get_ready")
_G.GoodinPrison = 0
_G.BadinPrison = 0
  for i = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
    player = PlayerResource:GetPlayer(i)
    --print(player)
      if (player ~=nil) then
        hero = player:GetAssignedHero()
        hero:AddNewModifier(nil, nil, "modifier_stunned", {duration = 3})
        gold = CONSTANTS.goldForPoint + _G.GAME_ROUND * 25
        --GIVE GOLD TO ALL UNITS AT EVERY RESET 
        hero:SetGold(hero:GetGold() + gold, false)
        --print(hero)
        if (hero ~=nil) then
      --hero:RemoveModifierByName("modifier_stunned")
          if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
            local point =  Entities:FindByName( nil, "radiantTP" ):GetAbsOrigin()
            FindClearSpaceForUnit(hero, point, false)
            hero:Stop()
            SendToConsole("dota_camera_center")
            hero:AddNewModifier(hero, nil, "modifier_stun", nil)
            print("goodreset")
            --Timers:CreateTimer(3)
            --hero:RemoveModifierByName("modifier_stun")
            --print("LAL")
          end
          if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
            local point =  Entities:FindByName( nil, "direTP" ):GetAbsOrigin()
            FindClearSpaceForUnit(hero, point, false)
            hero:Stop()
            SendToConsole("dota_camera_center")
            hero:AddNewModifier(hero, nil, "modifier_stun", nil)
            print("badreset")
            --Timers:CreateTimer(3)
            --hero:RemoveModifierByName("modifier_stun")
            --print("LAL")
          end
          for i = 0,5 do
            local item = hero:GetItemInSlot(i)
            if item then
              if item:GetAbilityName() == "item_capture_good_flag" then
                print("good flag forcibly dropped")
                hero:RemoveItem(item)
                spawnGoodFlag()
              end
              if item:GetAbilityName() == "item_capture_bad_flag" then
                print("bad flag forcibly dropped")
                hero:RemoveItem(item)
                spawnBadFlag()
              end
            end
          end
        end
      end
    end
  end


  --[[
  if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    print("button press bad")
    _G.Button = 2
   -- local arrow_neutral = Entities:FindByName(nil, arrow_neutral)
    --[[
    arrow_neutral:SetEnabled(false, false)
    arrow_neutral:SetEnabled(false) 
    arrow_bad:SetEnabled(true) 
    bad_button:SetEnabled(true)
    arrow_good:SetEnabled(false) 
    good_button:SetEnabled(false)
 
  end
  if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    print("button press good")
    _G.Button = 1
    --[[
    arrow_neutral:SetEnabled(false) 
    arrow_bad:SetEnabled(false) 
    bad_button:SetEnabled(false)
    arrow_good:SetEnabled(true) 
    good_button:SetEnabled(true)

  end
 --]]




