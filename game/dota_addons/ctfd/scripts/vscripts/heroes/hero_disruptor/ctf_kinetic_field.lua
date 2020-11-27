ctf_kinetic_field = class({})

function OnSpellStart( keys )
	local particle_field	= "particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf"
	local particle_cast		= "particles/units/heroes/hero_disruptor/disruptor_kineticfield_formation.vpcf"

	local caster 			= keys.caster
	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1

	local target_point		= keys.target_points[1]

	local field_radius 		= ability:GetLevelSpecialValueFor("field_radius", ability_level)
	local formation_time 	= ability:GetLevelSpecialValueFor("formation_time", ability_level)
	local field_duration 	= ability:GetLevelSpecialValueFor("field_duration", ability_level)

	local cast_fx	= ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)

	ParticleManager:SetParticleControl(cast_fx, 0, target_point)
	ParticleManager:SetParticleControl(cast_fx, 1, Vector(field_radius / 10, 0, 0))
	ParticleManager:SetParticleControl(cast_fx, 2, Vector(formation_time, 0, 0))


	Timers:CreateTimer(formation_time,
		function()
			local field_fx	= ParticleManager:CreateParticle(particle_field, PATTACH_ABSORIGIN, caster)

			ParticleManager:SetParticleControl(field_fx, 0, target_point)
			ParticleManager:SetParticleControl(field_fx, 1, Vector(field_radius, 0, 0))
			ParticleManager:SetParticleControl(field_fx, 2, Vector(field_duration, 0, 0))
		end
	)

end