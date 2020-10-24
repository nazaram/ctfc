ctf_void_spirit_astral_step = class({})

function OnSpellStart( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local particle_name 	= "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"

	caster_location = caster:GetAbsOrigin()
	ability_level = ability:GetLevel() - 1

	local radius 				= ability:GetLevelSpecialValueFor("radius", ability_level - 1)
	local min_travel_distance 	= ability:GetLevelSpecialValueFor("min_travel_distance", ability_level - 1)
	local max_travel_distance 	= ability:GetLevelSpecialValueFor("max_travel_distance", ability_level - 1)
	local move_slow_pct			= ability:GetLevelSpecialValueFor("move_slow_pct", ability_level - 1)
	local slow_duration 		= ability:GetLevelSpecialValueFor("slow_duration", ability_level - 1)

	local target_point			= keys.target_points[1]
	local target_direction		= target_point - caster_location
	local max_target_point 		= max_travel_distance * target_direction:Normalized()

	-- use bounding variable to restrict range of travel
	if target_direction:Length2D() > max_travel_distance then
		target_point = max_target_point + caster_location
	end

	FindClearSpaceForUnit( caster, target_point, true )
	
	particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster_location)
	ParticleManager:SetParticleControl(particle, 1, target_point)

end