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
	local particle_trail 	= "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"
	local main_ability_name = "techies_blast_off_ctf"
	local sub_ability_name 	= "techies_focused_detonation"
	local mine_model		= "models/heroes/techies/fx_techies_remotebomb.vmdl"
	local sound_launched	= "Hero_Techies.RemoteMine.Plant"
	local sound_fizzle		= "Hero_Techies.Debris"

	local caster 			= keys.caster
	local caster_location 	= caster:GetAbsOrigin()
	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1

	local max_range			= ability:GetLevelSpecialValueFor("max_range", ability_level)
	local projectile_speed	= ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	local target_point	 	= keys.target_points[1]

	local direction 		= (target_point - caster_location):Normalized()
	local distance			= (target_point - caster_location):Length2D()

	dummy					= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())

	-- Ability Logic Proper
	caster:EmitSound(sound_launched)
	caster:AddNewModifier(caster, ability, "modifier_detonation_time", {duration = max_range/projectile_speed})
	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

	dummy:SetOriginalModel(mine_model)
	dummy:SetModel(mine_model)
	dummy:AddNewModifier(dummy, nil, "modifier_no_healthbar", {duration = -1})

	Physics:Unit(dummy)

	dummy:PreventDI(true)
	dummy:SetAutoUnstuck(true)
	dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy:FollowNavMesh(false)
	dummy:SetPhysicsVelocityMax(projectile_speed)
	dummy:SetPhysicsVelocity(projectile_speed * direction)
	dummy:SetPhysicsFriction(0)
	dummy:Hibernate(false)
	dummy:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	dummy:OnPhysicsFrame(
		function()
			local progress = (dummy:GetAbsOrigin() - caster_location):Length2D()

			dummy:SetForwardVector(dummy:GetPhysicsVelocity())

			if progress >= max_range then
				dummy:RemoveSelf()
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
	local dummy_location		= dummy:GetAbsOrigin()

	local radius				= ability:GetLevelSpecialValueFor("radius", ability_level)
	local silence_duration 		= ability:GetLevelSpecialValueFor("silence_duration", ability_level)
	local slow_duration			= ability:GetLevelSpecialValueFor("slow_duration", ability_level)
	-- gslow 						= ability:GetLevelSpecialValueFor("movespeed_slow", ability_level)

	local explosion_fx 			= ParticleManager:CreateParticle(particle_explosion, PATTACH_ABSORIGIN, caster)

	ParticleManager:SetParticleControl(explosion_fx, 0, dummy:GetAbsOrigin())
	dummy:EmitSound(sound_explosion)
	caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)

	local units = FindUnitsInRadius(
	caster:GetTeamNumber(), 
	dummy_location, 
	nil,
	radius, 
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO, 
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)

	for _, unit in ipairs(units) do
		if (unit:GetAbsOrigin() - dummy_location):Length2D() < radius then
			print(units)
			-- unit:AddNewModifier(caster, ability, "modifier_blast_off", {duration = slow_duration})
			-- unit:AddNewModifier(caster, ability, "MODIFIER_STATE_SILENCED", {duration = silence_duration})
		end
	end

	dummy:RemoveSelf()
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