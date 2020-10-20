-- Generated from template

require("libraries/physics")
require("libraries/timers")
require("libraries/status_resistance")
require("shared_abilities/torrent")
require("shared_abilities/solar_crest_hvh")

LinkLuaModifier("modifier_status_resistance", "libraries/status_resistance.lua", LUA_MODIFIER_MOTION_NONE)


if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

if score == nil then
  score = class({})
  score.Bad = 0
  score.Good = 0
end

if CONSTANTS == nil then
  CONSTANTS = {}
  CONSTANTS.scoreToWin = 10
  CONSTANTS.goldForPoint = 50
  CONSTANTS.goldForCatch = 25
  CONSTANTS.goldForSave = 25
  CONSTANTS.experience = 1000
  -- using this for scoreboard
  -- deny is point
  -- kill is catch
  -- death is be caught
  -- assist is save a friend
end

  _G.BountyPickedGood = 1
  _G.BountyPickedBad = 1

  _G.GoodHasFlag = 0
  _G.BadHasFlag = 0
    
  _G.Button = 0

_G.GAME_ROUND = 1

_G.GAME_ROUND1experiencelose = 75
_G.GAME_ROUND1experiencewin = 150

_G.GAME_ROUND2experiencelose = 85
_G.GAME_ROUND2experiencewin =  175

_G.GAME_ROUND3experiencelose = 95
_G.GAME_ROUND3experiencewin = 185

_G.GAME_ROUND4experiencelose = 100
_G.GAME_ROUND4experiencewin = 200

_G.GAME_ROUND5experiencelose = 125
_G.GAME_ROUND5experiencewin = 200

_G.GAME_ROUND6experiencelose = 200
_G.GAME_ROUND6experiencewin = 225

_G.GAME_ROUND7experiencelose = 225
_G.GAME_ROUND7experiencewin = 250

_G.GAME_ROUND8experiencelose = 250
_G.GAME_ROUND8experiencewin = 275

_G.GAME_ROUND9experiencelose = 275
_G.GAME_ROUND9experiencewin = 300

_G.GAME_ROUND10experiencelose = 300
_G.GAME_ROUND10experiencewin = 325

_G.GAME_ROUND11experiencelose = 325
_G.GAME_ROUND11experiencewin = 400

_G.GAME_ROUND12experiencelose = 400
_G.GAME_ROUND12experiencewin = 425

_G.GAME_ROUND13experiencelose = 425
_G.GAME_ROUND13experiencewin = 450

_G.GAME_ROUND14experiencelose = 450
_G.GAME_ROUND14experiencewin = 475

_G.GAME_ROUND15experiencelose = 475
_G.GAME_ROUND15experiencewin = 500

_G.GAME_ROUND16experiencelose = 700
_G.GAME_ROUND16experiencewin = 800

_G.GAME_ROUND17experiencelose = 900
_G.GAME_ROUND17experiencewin = 1000

_G.GAME_ROUND18experiencelose = 950
_G.GAME_ROUND18experiencewin = 1050

_G.GAME_ROUND19experiencelose = 9070
_G.GAME_ROUND19experiencewin = 1070

_G.GAME_ROUND20experiencelose = 1000
_G.GAME_ROUND20experiencewin = 1200

_G.GoodPlayers = 0
_G.BadPlayers = 0

_G.GoodinPrison = 0
_G.BadinPrison = 0


function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

XP_PER_LEVEL_TABLE = {
     0, -- 1
   100,	-- 2
   250,	-- 3
   350,	-- 4
  575,	-- 5
  675,	-- 6
  1050,	-- 7
  2000,	-- 8
  4200,	-- 9
  5600,	-- 10
 200000,	-- 11
 200000,	-- 12
 200000,	-- 13
 200000,	-- 14
 200000,	-- 15
 200000,	-- 16
 200000,	-- 17
 200000,	-- 18
 200000,	-- 19
200000,	-- 20
200000,	-- 21
200000,	-- 22
200000,	-- 23
200000,	-- 24
200000 	-- 25
}


_G.startflag = 0

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
  print( "Template addon is loaded." )
  local GameMode = GameRules:GetGameModeEntity()
  --Override the values of the team values on the top game bar.
  GameMode:SetPauseEnabled(true)
  GameMode:SetCustomScanCooldown(30) 
  --GameMode:SetUseCustomHeroLevels(true)
  --GameMode:SetCustomHeroMaxLevel(10) 
  --GameMode:SetGoldPerTick(10.0) 
  --GameMode:SetGoldTickTime(1.0)
  GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
  GameMode:SetUseCustomHeroLevels( true )

  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, 2)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, 0)
  GameMode:SetTopBarTeamValuesOverride(true)
  GameMode:SetTopBarTeamValuesVisible(false)

  GameMode:SetRecommendedItemsDisabled(true)
	
  GameRules:SetStrategyTime(0)
  GameRules:SetShowcaseTime(0)
  GameRules:SetPreGameTime( 15.0)
  GameRules:SetTreeRegrowTime(100)
  GameRules:SetStartingGold(400)
  GameRules:SetUseUniversalShopMode(false) 
  GameRules:SetSameHeroSelectionEnabled(true)
  GameRules:SendCustomMessage("Welcome To Capture The Flag Alpha by buymyhat.com", DOTA_TEAM_NOTEAM, 0)
  GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
  print(" Gamemode rules are set.")
  GameRules:GetGameModeEntity():SetThink( "XpThink", self, "ExperienceThink", 0.25 )

  ListenToGameEvent('npc_spawned', Dynamic_Wrap(CAddonTemplateGameMode, 'OnNPCSpawned'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(CAddonTemplateGameMode, 'OnEntityHurt'), self)
  ListenToGameEvent("entity_killed", Dynamic_Wrap(CAddonTemplateGameMode, "OnEntityKilled"), self)
  ListenToGameEvent("PickupRune", Dynamic_Wrap(CAddonTemplateGameMode, "PickupRune"), self)
  ListenToGameEvent("dota_player_pick_hero", OnHeroPicked, nil)
  ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap(CAddonTemplateGameMode, "OnItemPickUp"), self )
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
  --ListenToGameEvent('OnGameInProgress', Dynamic_Wrap(GameMode, 'OnGameInProgress'), self)

  --GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap(CAddonAdvExGameMode, "ItemAddedFilter"), self )
  spawnGoodFlag()
  spawnBadFlag()
  Timers:CreateTimer( 24,   function()
      print("hi aram")
      spawnBountyRune()
        return 30.0
    end
  )
  GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)

end



-- function CAddonTemplateGameMode:OnGameInProgress()
--   print("[BAREBONES] The game has officially begun")
--    Timers:CreateTimer( 0,   function()
--       print("hi aram")
--         return 60.0
--     end
--   )





function CAddonTemplateGameMode:XpThink()

	-- Check if the game is actual over
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	else
		
		-- Loop for every Player
		for xpPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			teamID = PlayerResource:GetTeam(xpPlayerID)
			teamXP = 0
			
			-- Get the highest XP value in Team of the current player
			for teamPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:GetTeam(teamPlayerID) == teamID then
					if teamXP < PlayerResource:GetTotalEarnedXP(teamPlayerID) then
						teamXP = PlayerResource:GetTotalEarnedXP(teamPlayerID)
					end
				end
			end			
			
			-- Give XP to current Player if needed
			if PlayerResource:GetSelectedHeroEntity(xpPlayerID) ~= nil then
				if teamXP > PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetCurrentXP() then
					PlayerResource:GetSelectedHeroEntity(xpPlayerID):AddExperience(teamXP - PlayerResource:GetSelectedHeroEntity(xpPlayerID):GetCurrentXP(), false)
				end
			end
		end
		-- Repeater Thinker every 0.25 seconds
		return 0.25
	end
end




 function OnHeroPicked (event)
    _G.startflag = _G.startflag + 1
    local hero = EntIndexToHScript(event.heroindex)
    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      _G.GoodPlayers = _G.GoodPlayers + 1
    end

    if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
      _G.BadPlayers =   _G.BadPlayers + 1
    end

    hero:AddNewModifier(nil, nil, "modifier_stunned", {duration = 5})
    
    if _G.startflag == 1 then
      GameRules:SendCustomMessage("<font color='#e5e5e5'> Welcome to Capture the Flag sponsored by </font>" .. "<font color='#ff3232'>buymyhat.com</font>", DOTA_TEAM_NOTEAM, 0)
    end

    if hero:HasRoomForItem("item_quelling_blade", true, true) then
       local blade = CreateItem("item_quelling_blade", hero, hero)
       blade:SetPurchaseTime(0)
       hero:AddItem(blade)
    end

 if hero:HasRoomForItem("item_ironwood_tree", true, true) then
       local tree = CreateItem("item_ironwood_tree", hero, hero)
       tree:SetPurchaseTime(0)
       hero:AddItem(tree)
    end
 end


function CAddonTemplateGameMode:OnItemPickUp(keys)
	local hero = EntIndexToHScript(keys.HeroEntityIndex)
	local itempicked = EntIndexToHScript(keys.ItemEntityIndex)
	local itemname = keys.itemname
	if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    for i = 0,5 do
      local item = hero:GetItemInSlot(i)
      if item then
        --print("item:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_good_flag" then
          --print("found the item!")
          hero:RemoveItem(item)
          spawnGoodFlag()
          print("good guy drop their own flag")
        end
      end
    end
    end
    if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    for i = 0,5 do
      local item = hero:GetItemInSlot(i)
      if item then
        --print("item:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_bad_flag" then
         -- print("found the item!")
          hero:RemoveItem(item)
          spawnBadFlag()
          print("bad guy drop their own flag")
        end
      end
    end
    end
end


-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function spawnGoodFlag()
  print("spawnGoodFlag")
--  local flag = CreateItem("item_capture_good_flag", nil, nil)
--  CreateItemOnPositionSync(Vector(-1822.81, -636.813, 128), flag)
  local flag = CreateItem("item_capture_good_flag", nil, nil)
  CreateItemOnPositionSync(Vector(-3309.73, 528.231, 142.448), flag)
  _G.BadHasFlag = 0

end

function spawnBadFlag()
  print("spawnBadFlag")
  --local flag = CreateItem("item_capture_bad_flag", nil, nil)
  --CreateItemOnPositionSync(Vector(-153.281, 2337.62, 128), flag)
  local flag = CreateItem("item_capture_bad_flag", nil, nil)
  CreateItemOnPositionSync(Vector(4093.02, 384.78, 140.719), flag)
   _G.GoodHasFlag = 0
end

function spawnBountyRune()

  local i = RandomInt(1,3)
  local z = RandomInt(4,6)
  print(i)
  print(z)
  local bountyrune= CreateItem("item_bounty_rune", nil, nil)  
  local bountyrune1 = CreateItem("item_bounty_rune_A", nil, nil)  
  local bountyrune2 = CreateItem("item_bounty_rune_B", nil, nil)  
  local bountyrune3 = CreateItem("item_bounty_rune_C", nil, nil)  
  local bountyrune4 = CreateItem("item_bounty_rune_D", nil, nil)  
  local bountyrune5 = CreateItem("item_bounty_rune_E", nil, nil)  
  local bountyrune6 = CreateItem("item_bounty_rune_F", nil, nil)  




  if _G.BountyPickedGood == 1 then
    if(i==1) then
      local point =  Entities:FindByName( nil, "Bounty1" ):GetAbsOrigin()
     -- local bountyrune = CreateItem("item_bounty_rune", nil, nil)
      CreateItemOnPositionSync(Vector(-1845.27, 2667.82, 472.407),bountyrune1)
    end
    if(i==2) then
      local point =  Entities:FindByName( nil, "Bounty2" ):GetAbsOrigin()
     -- local bountyrune = CreateItem("item_bounty_rune", nil, nil)
      CreateItemOnPositionSync(Vector(-3430.15, 3198.03, 331.071), bountyrune2)
    end
    if(i==3) then
      local point =  Entities:FindByName( nil, "Bounty3" ):GetAbsOrigin()
      --local bountyrune = CreateItem("item_bounty_rune", nil, nil)
      CreateItemOnPositionSync(Vector(-1993.54, -653.823, 438.064), bountyrune3)
    end
    _G.BountyPickedGood = 0
  end

  if _G.BountyPickedBad == 1 then
    if(z==4) then
      print("creating 4")
      local point =  Entities:FindByName( nil, "Bounty4" ):GetAbsOrigin()
      --local bountyrune = CreateItem("item_bounty_rune", nil, nil)
      CreateItemOnPositionSync(Vector(2499.64, 2673.39, 427.251), bountyrune4)
    end
      if(z==5) then
      print("creating 5")
      local point =  Entities:FindByName( nil, "Bounty5" ):GetAbsOrigin()
     -- local bountyrune = CreateItem("item_bounty_rune", nil, nil)
      CreateItemOnPositionSync(Vector(4099.58, 3192.45, 342.538), bountyrune5)
    end
      if(z==6) then
      print("creating 6")
      local point =  Entities:FindByName( nil, "Bounty6" ):GetAbsOrigin()
     -- local bountyrune = CreateItem("item_bounty_rune", nil, nil)
      CreateItemOnPositionSync(Vector(2618.97, -678.654, 440.487), bountyrune6)
    end
    _G.BountyPickedBad = 0 
  end

end



function reset()
  print("reset")
  EmitGlobalSound("get_ready")

_G.GoodinPrison = 0
_G.BadinPrison = 0


  _G.GAME_ROUND = _G.GAME_ROUND + 1
  GameRules:SendCustomMessage("<font color='#a000a0'> Get Ready for Round ".. _G.GAME_ROUND .. "!</font>", DOTA_TEAM_NOTEAM, 0)
 -- local heroes = GetAllRealHeroes()
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



 local WhoHasFlag = 
    {
    GoodHasFlag = _G.GoodHasFlag, 
    BadHasFlag = _G.BadHasFlag 
    } 

    
    CustomGameEventManager:Send_ServerToAllClients("has_flag", WhoHasFlag )
end


function CAddonTemplateGameMode:OnNPCSpawned(keys)
  local hero = EntIndexToHScript(keys.entindex)
  hero:SetBaseAttackTime(1)
  print(hero)
  print(hero:GetBaseAttackTime())
  if hero:IsHero() then
    print("OnNPCSpawnedX")
    hero:SetAbilityPoints(1)
    torrent_jail = hero:FindAbilityByName("torrent_datadriven")
    torrent_jail:SetLevel(1) 
    torrent_jail:SetActivated(false)
  end

  local entity = EntIndexToHScript(keys.entindex)
  local innateAbilityName1 = "bounty_hunter_jinada"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName1) then
    entity:FindAbilityByName(innateAbilityName1):SetLevel(1)
  end

  local innateAbilityName2 = "rattletrap_rocket_flare"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName2) then
    entity:FindAbilityByName(innateAbilityName2):SetLevel(1)
  end
  
  local innateAbilityName3 = "creature_self_haste"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName3) then
    entity:FindAbilityByName(innateAbilityName3):SetLevel(1)
  end
  
  local innateAbilityName4 = "void_spirit_astral_step"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName4) then
    entity:FindAbilityByName(innateAbilityName4):SetLevel(1)
  end

  local innateAbilityName5 = "spirit_breaker_bulldoze"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName5) then
    entity:FindAbilityByName(innateAbilityName5):SetLevel(1)
  end

  local innateAbilityName6 = "tiny_grow"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName6) then
    entity:FindAbilityByName(innateAbilityName6):SetLevel(1)
  end

  local innateAbilityName7 = "inferno_dragon_wave"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName7) then
    entity:FindAbilityByName(innateAbilityName7):SetLevel(1)
  end

  local innateAbilityName8 = "demonhunter_evasion"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName8) then
    entity:FindAbilityByName(innateAbilityName8):SetLevel(1)
  end

  local innateAbilityName9 = "old_antimage_blink"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName9) then
    entity:FindAbilityByName(innateAbilityName9):SetLevel(1)
  end

  local innateAbilityName10 = "kunkka_tidebringer"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName10) then
    entity:FindAbilityByName(innateAbilityName10):SetLevel(1)
  end

  local innateAbilityName11 = "disruptor_static_storm"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName11) then
    entity:FindAbilityByName(innateAbilityName11):SetLevel(1)
  end


  local innateAbilityName12 = "windrunner_powershot"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName12) then
    entity:FindAbilityByName(innateAbilityName12):SetLevel(1)
  end

  local innateAbilityName13 = "earthshaker_aftershock"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName13) then
    entity:FindAbilityByName(innateAbilityName13):SetLevel(1)
  end

  local innateAbilityName14 = "mirana_invis"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName14) then
    entity:FindAbilityByName(innateAbilityName14):SetLevel(1)
  end

local innateAbilityName15 = "vengefulspirit_magic_missile"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName15) then
    entity:FindAbilityByName(innateAbilityName15):SetLevel(1)
  end

local innateAbilityName16 = "tusk_frozen_sigil"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName16) then
    entity:FindAbilityByName(innateAbilityName16):SetLevel(1)
  end

local innateAbilityName17 = "ctf_waveform"
  if entity:IsRealHero() and entity:HasAbility(innateAbilityName17) then
    entity:FindAbilityByName(innateAbilityName17):SetLevel(1)
  end

end


function CAddonTemplateGameMode:OnEntityHurt(tbl)
        print("!!! BEGIN OnEntityHurt !!!")
        local victim = EntIndexToHScript(tbl.entindex_killed)
        local attacker = EntIndexToHScript(tbl.entindex_attacker)
        print(attacker:GetName() .. " is attacking " .. victim:GetName())
        -- DeepPrintTable(tbl)
        print("!!! END OnEntityHurt !!!")
        --CTF:Teleport(victim, attacker)
        --CTF:JailRelease(victim, attacker)
end

function CAddonTemplateGameMode:OnGameRulesStateChange()
        local nNewState = GameRules:State_Get()
        if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
                print( "[CTF] Gamemode is running." )
                ShowGenericPopup( "#CTF_instructions_title", "#CTF_instructions_body", "", "", DOTA_SHOWGENERICPOPUP_TINT_SCREEN )
        end
end

function CAddonTemplateGameMode:OnEntityHurt(tbl)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)
  print( "SOMEONE GOT HURT" )

  local victim = EntIndexToHScript(tbl.entindex_killed)
  local attacker = EntIndexToHScript(tbl.entindex_attacker)

  
  attacker:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
  victim:EmitSound("DOTA_Item.Dagon5.Target")

  victim:AddNewModifier(nil, nil, "modifier_stunned", {duration = 3})

  if attacker:IsHero() then
    attacker:AddExperience(15 + _G.GAME_ROUND * 3 , DOTA_ModifyXP_Unspecified, false, false)
    --attacker:AddExperience(hero:GetCurrentXP() + 100, DOTA_ModifyXP_Unspecified, false, false)
    attacker:SetGold(attacker:GetGold() + 15 + _G.GAME_ROUND * 7, false)
  end


  if attacker:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    for i = 0,5 do
      local item = victim:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" or item:GetAbilityName() == "item_capture_good_flag" then
          victim:RemoveItem(item)
          GameRules:SendCustomMessage("<font color='#ff4c4c'>Bad Guys' Flag Has Been Dropped</font>", DOTA_TEAM_NOTEAM, 0)
          spawnBadFlag()          
        end
      end
    end       
  local ent = Entities:FindByName( nil, "point_teleport_jail_dire" ):GetAbsOrigin()
  FindClearSpaceForUnit(victim, ent, false)
  victim:Stop()
  --victim:AddNewModifier(victim, nil, "modifier_invulnerable", nil)
  print("inv")
  end

  if attacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    for i = 0,5 do
    local item = victim:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" or item:GetAbilityName() == "item_capture_good_flag" then
          victim:RemoveItem(item)
          GameRules:SendCustomMessage("<font color='#66b266'>Good Guys' Flag Has Been Dropped</font>", DOTA_TEAM_NOTEAM, 0)
          spawnGoodFlag()          
        end
      end
    end      
  
  local ent = Entities:FindByName( nil, "point_teleport_jail_radiant" ):GetAbsOrigin()
  FindClearSpaceForUnit(victim, ent, false)
  victim:Stop()
  --victim:AddNewModifier(victim, nil, "modifier_invulnerable", nil)
  print("inv")
  end


 local WhoHasFlag = 
    {
    GoodHasFlag = _G.GoodHasFlag, 
    BadHasFlag = _G.BadHasFlag 
    } 
    CustomGameEventManager:Send_ServerToAllClients("has_flag", WhoHasFlag )

end

function CAddonTemplateGameMode:OnEntityKilled (event)
	print("Someone Died Lol")
	local killedEntity = EntIndexToHScript(event.entindex_killed)
	if killedEntity ~= nil then
	end
end


function updateScore(scoreGood, scoreBad)
  
   local score_obj = 
    {
        radi_score = scoreGood,
        dire_score = scoreBad
    }
    
    CustomGameEventManager:Send_ServerToAllClients( "refresh_score", score_obj )

  print("Updating score: " .. scoreGood .. " x " .. scoreBad)

  local GameMode  = GameRules:GetGameModeEntity()

  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, scoreGood) 
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, scoreBad) 


  --GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, scoreGood)
  --GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, scoreBad)
 -- GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, scoreGood)
  --GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, scoreBad)

  -- If any team reaches scoreToWin, the game ends and that team is considered winner.
  if scoreGood == CONSTANTS.scoreToWin then
    print("Team GOOD GUYS victory!")
    EmitGlobalSound("Loot_Drop_Stinger_Arcana")
    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
  end
  if scoreBad == CONSTANTS.scoreToWin then
    print("Team BAD GUYS victory!")
    EmitGlobalSound("Loot_Drop_Stinger_Arcana")
    GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
  end
end





--[[
function CAddonTemplateGameMode:ItemAddedFilter( keys )
  print("ItemAddedFilter")
  local unit = EntIndexToHScript(keys.inventory_parent_entindex_const)
  local item = EntIndexToHScript(keys.item_entindex_const)
  local item_name = 0
  print(item)
  if item:GetName() then
    item_name = item:GetName()
    print(item_name)
  end
  -------------------------------------------------------------------------------------------------
  -- Rune pickup logic
  -------------------------------------------------------------------------------------------------
  if item_name == "item_rune_bounty" then

    -- Only real heroes can pick up runes
    --if unit:IsRealHero() then
      if item_name == "item_rune_bounty" then
        PickupBountyRune(item, unit)
        return false
      end

      if item_name == "item_rune_double_damage" then
        PickupDoubleDamageRune(item, unit)
        return false
      end

      if item_name == "item_rune_haste" then
        PickupHasteRune(item, unit)
        return false
      end

      if item_name == "item_rune_regeneration" then
        PickupRegenerationRune(item, unit)
        return false
      end

    -- If this is not a real hero, drop another rune in place of the picked up one
    -- else
    --  local new_rune = CreateItem(item_name, nil, nil)
    --  CreateItemOnPositionForLaunch(item:GetAbsOrigin(), new_rune)
    --  return false
    -- end
  end
  return true
end
]]--



--[[
function point(nameHero)
  print("Check NAMEHERO:")
  print(nameHero)
  if nameHero == CONSTANTS.goodGuysHero then
    print("Radiant Point!}")
    GameRules:SendCustomMessage("Good Guys Scored", DOTA_TEAM_NOTEAM, 0)
    score.Good = score.Good + 1
  else
    print("Dire Point!")
    GameRules:SendCustomMessage("Bad Guys Scored", DOTA_TEAM_NOTEAM, 0)
    score.Bad = score.Bad + 1
  end
  updateScore(score.Good, score.Bad)
  -- gold for the team how made point
 print("pre")
 ]]--
  
--end

function pointBad()
    print("Bad Team Point!}")
    GameRules:SendCustomMessage("<font color='#ff0000'>Bad Guys Scored </font>", DOTA_TEAM_NOTEAM, 0)
    score.Bad = score.Bad + 1
    updateScore(score.Good, score.Bad)
    EmitGlobalSound("DOTA_Item.ShivasGuard.Activate")

end

function pointGood()
    print("Good Team Point!}")
    GameRules:SendCustomMessage("<font color='#007300'> Good Guys Scored! </font>", DOTA_TEAM_NOTEAM, 0)
    score.Good = score.Good + 1
    updateScore(score.Good, score.Bad)
    EmitGlobalSound("Tutorial.Quest.complete_01")
end









--[[
function GetAllRealHeroes()
    local rheroes = {}
    local heroes = HeroList:GetAllHeroes()
    
    for i=1,#heroes do
        if heroes[i]:IsRealHero() then
            print("woo")
            print(heroes[i])
            print("woo")
            table.insert(rheroes,heroes[i])
        end
    end
    return rheroes
end
]]--


