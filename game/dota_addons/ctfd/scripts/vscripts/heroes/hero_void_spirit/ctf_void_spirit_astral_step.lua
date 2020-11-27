LinkLuaModifier("modifier_void_mark", "heroes/hero_void_spirit/ctf_void_spirit_astral_step.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_charges", "libraries/modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE)

ctf_void_spirit_astral_step = class({})

function OnUpgrade( keys )
	local caster = keys.caster 
	local ability = keys.ability 

	caster:AddNewModifier(caster, ability, "modifier_charges", {
		max_count = ability:GetLevelSpecialValueFor("max_charges", ability:GetLevel() - 1),
		replenish_time = ability:GetLevelSpecialValueFor("charge_restore_time", ability:GetLevel() - 1)
	})
end

function OnSpellStart( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local particle_name 	= "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"

	caster_location = caster:GetAbsOrigin()
	ability_level = ability:GetLevel()

	local radius 				= ability:GetLevelSpecialValueFor("radius", ability_level - 1)
	local min_travel_distance 	= ability:GetLevelSpecialValueFor("min_travel_distance", ability_level - 1)
	local max_travel_distance 	= ability:GetLevelSpecialValueFor("max_travel_distance", ability_level - 1)
	local move_slow_pct			= ability:GetLevelSpecialValueFor("move_slow_pct", ability_level - 1)
	local slow_duration 		= ability:GetLevelSpecialValueFor("slow_duration", ability_level - 1)

	local target_point			= keys.target_points[1]
	local target_direction		= target_point - caster_location
	local max_target_point 		= max_travel_distance * target_direction:Normalized()
	local min_target_point		= min_travel_distance * target_direction:Normalized()

	-- use bounding variable to restrict range of travel while still giving void spirit the ability to cast the ability anywhere and void will travel in that direction
	if target_direction:Length2D() > max_travel_distance then
		target_point = max_target_point + caster_location
	elseif target_direction:Length2D() < min_travel_distance then
		target_point = min_target_point + caster_location
	end

	FindClearSpaceForUnit( caster, target_point, true )
	
	particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster_location)
	ParticleManager:SetParticleControl(particle, 1, target_point)

	local units = FindUnitsInLine(caster:GetTeamNumber(), caster_location, target_point, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)


	for _, unit in ipairs(units) do
		unit:AddNewModifier(caster, ability, "modifier_void_mark", {duration = slow_duration})					
	end
end

modifier_void_mark = class({})

gslow = -80

function modifier_void_mark:IsHidden()
	return false
end

function modifier_void_mark:IsDebuff()
	return true
end

function modifier_void_mark:IsPurgable()
	return true
end

function modifier_void_mark:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_void_mark:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_void_mark:GetTexture()
	return "void_spirit_astral_step"
end

function modifier_void_mark:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_void_mark:GetModifierMoveSpeedBonus_Percentage()
	return gslow
end
