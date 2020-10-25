ctf_techies_artillery = class({})

function OnSpellStart( keys )
	local particle_name			= "particles/units/heroes/hero_techies/techies_base_attack_model.vpcf"
	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()
	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local shell_speed			= ability:GetLevelSpecialValueFor("shell_speed", ability_level)
	local min_distance			= ability:GetLevelSpecialValueFor("min_distance", ability_level)
	local blast_radius			= ability:GetLevelSpecialValueFor("blast_radius", ability_level)
	local knockback_distance 	= ability:GetLevelSpecialValueFor("knockback_distance", ability_level)


	local target_point			= keys.target_points[1]
	local direction 			= target_point - caster_location
	local theta					= 60

	if direction:Length2D() < min_distance then
		direction = min_distance * direction:Normalized()
	end

	-- direction = RotatePosition(Vector(0, 0, 0), QAngle(theta, 0, 0), direction)

	local dummy				= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	dummy:AddNewModifier(dummy, nil, "modifier_no_healthbar", {duration = -1})
	local particle 			= ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, dummy)

	Physics:Unit(dummy)

	dummy:PreventDI(true)
	dummy:SetAutoUnstuck(true)
	dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy:FollowNavMesh(false)
	dummy:SetPhysicsVelocityMax(shell_speed)
	dummy:SetPhysicsVelocity(shell_speed * direction)
	dummy:SetPhysicsFriction(0)
	dummy:Hibernate(false)
	dummy:SetGroundBehavior(PHYSICS_GROUND_ABOVE)

	dummy:OnPhysicsFrame(
		function()
			dummy:SetForwardVector(dummy:GetPhysicsVelocity())
			ParticleManager:SetParticleControl(particle, 3, dummy:GetAbsOrigin())

			if (dummy:GetAbsOrigin() - caster_location):Length2D() >= direction:Length2D() then
				
				local push_start_point = dummy:GetAbsOrigin()
				local push_end_point = (- blast_radius * (caster_location - push_start_point):Normalized()) + push_start_point
				dummy:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle)

				local units = FindUnitsInLine(caster:GetTeamNumber(), push_start_point, push_end_point, caster, blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

				for _, unit in ipairs(units) do
					FindClearSpaceForUnit( unit, (- knockback_distance * (caster_location - push_start_point):Normalized()) + unit:GetAbsOrigin(), false )
				end

			end
		end
		)
end