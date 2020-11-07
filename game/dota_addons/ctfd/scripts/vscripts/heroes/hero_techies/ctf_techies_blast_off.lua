LinkLuaModifier("modifier_detonation_time", "heroes/hero_techies/ctf_techies_blast_off", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blast_off", "heroes/hero_techies/ctf_techies_blast_off", LUA_MODIFIER_MOTION_NONE)

ctf_techies_blast_off = class({})

function OnUpgrade( keys )
	local caster 				= keys.caster
	local sub_ability_name 		= "techies_focused_detonation"
	local sub_ability 			= caster:FindAbilityByName(sub_ability_name)

	sub_ability:SetLevel(1)
	sub_ability:UpgradeAbility(true)
	sub_ability:SetActivated(true)
end

function OnSpellStart( keys )
	-- Initialize Variables and Key Values
	local particle_trail 		= "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"
	local main_ability_name 	= "techies_blast_off_ctf"
	local sub_ability_name 		= "techies_focused_detonation"
	local remote_model			= "models/heroes/techies/fx_techies_remotebomb.vmdl"
	local mine_model			= "models/heroes/techies/fx_techiesfx_landmine.vmdl"
	local sound_launched		= "Hero_Techies.RemoteMine.Plant"
	local sound_fizzle			= "Hero_Techies.Debris"

	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()
	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local max_range				= ability:GetLevelSpecialValueFor("max_range", ability_level)
	local projectile_speed		= ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local placement_interval 	= ability:GetLevelSpecialValueFor("placement_interval", ability_level)

	local target_point	 		= keys.target_points[1]

	local direction 			= (target_point - caster_location):Normalized()
	local distance				= (target_point - caster_location):Length2D()
	local detonation_timing		= max_range/projectile_speed
	local mine_timing 			= detonation_timing / placement_interval

	dummy_remote				= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())

	-- Ability Logic Proper
	caster:EmitSound(sound_launched)
	caster:AddNewModifier(caster, ability, "modifier_detonation_time", {duration = detonation_timing})
	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

	dummy_remote:SetOriginalModel(remote_model)
	dummy_remote:SetModel(remote_model)
	dummy_remote:AddNewModifier(dummy_remote, nil, "modifier_no_healthbar", {duration = -1})

	Physics:Unit(dummy_remote)

	dummy_remote:PreventDI(true)
	dummy_remote:SetAutoUnstuck(true)
	dummy_remote:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_remote:FollowNavMesh(false)
	dummy_remote:SetPhysicsVelocityMax(projectile_speed)
	dummy_remote:SetPhysicsVelocity(projectile_speed * direction)
	dummy_remote:SetPhysicsFriction(0)
	dummy_remote:Hibernate(false)
	dummy_remote:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	-- Timers:CreateTimer(
	-- 	function()
	-- 		
	-- 		return mine_timing
	-- 	end 
	-- )

	local remote_start_time = GameRules:GetGameTime()

	dummy_remote:OnPhysicsFrame(
		function()
			local progress = (dummy_remote:GetAbsOrigin() - caster_location):Length2D()
			local point_prev = dummy_remote:GetAbsOrigin()

			dummy_remote:SetForwardVector(dummy_remote:GetPhysicsVelocity())

			if progress < max_range then
				if dummy_remote:GetAbsOrigin() - point_prev >= max_range / placement_interval then

				end

			else
				dummy_remote:RemoveSelf()
				caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)
			end
		end
	)
end

function Detonate( keys )
	local main_ability_name 	= "techies_blast_off_ctf"
	local sub_ability_name 		= "techies_focused_detonation"
	local particle_explosion 	= "particles/units/heroes/hero_techies/techies_suicide.vpcf"
	local sound_explosion 		= "Hero_Techies.Suicide"

	local caster 				= keys.caster
	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1
	local dummy_remote_location	= dummy_remote:GetAbsOrigin()

	local radius				= ability:GetLevelSpecialValueFor("radius", ability_level)
	local silence_duration 		= ability:GetLevelSpecialValueFor("silence_duration", ability_level)
	local slow_duration			= ability:GetLevelSpecialValueFor("slow_duration", ability_level)
	-- gslow 						= ability:GetLevelSpecialValueFor("movespeed_slow", ability_level)

	local explosion_fx 			= ParticleManager:CreateParticle(particle_explosion, PATTACH_ABSORIGIN, caster)

	ParticleManager:SetParticleControl(explosion_fx, 0, dummy_remote:GetAbsOrigin())
	dummy_remote:EmitSound(sound_explosion)
	caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)

	local units = FindUnitsInRadius(
	caster:GetTeamNumber(), 
	dummy_remote_location, 
	nil,
	radius, 
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO, 
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)

	for _, unit in ipairs(units) do
		if (unit:GetAbsOrigin() - dummy_remote_location):Length2D() < radius then
			print("units: ", units)
			-- unit:AddNewModifier(caster, ability, "modifier_blast_off", {duration = slow_duration})
			-- unit:AddNewModifier(caster, ability, "MODIFIER_STATE_SILENCED", {duration = silence_duration})
		end
	end

	dummy_remote:RemoveSelf()
end



modifier_blast_off = class({})

gslow = -75

function modifier_blast_off:IsHidden()
	return false
end

function modifier_blast_off:IsDebuff()
	return true
end

function modifier_blast_off:IsPurgable()
	return true
end

function modifier_blast_off:GetEffectName()
	return "particles/econ/items/techies/techies_arcana/techies_ambient_arcana_mouthfire.vpcf"
end

function modifier_blast_off:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_blast_off:GetTexture()
	return "techies_minefield_sign"
end

function modifier_blast_off:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_blast_off:GetModifierMoveSpeedBonus_Percentage()
	return gslow
end



modifier_detonation_time = class({})

function modifier_detonation_time:IsHidden()
	return false
end

function modifier_detonation_time:IsDebuff()
	return false
end

function modifier_detonation_time:IsPurgable()
	return false
end

function modifier_detonation_time:GetTexture()
	return "techies_focused_detonate"
end