ctf_techies_artillery = class({})

function OnSpellStart( keys )
	local particle_name			= "particles/units/heroes/hero_techies/techies_base_attack_model.vpcf"
	local particle_explosion	= "particles/units/heroes/hero_techies/techies_land_mine_ball_explosion.vpcf"
	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()
	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local shell_speed			= ability:GetLevelSpecialValueFor("shell_speed", ability_level)
	local min_distance			= ability:GetLevelSpecialValueFor("min_distance", ability_level)
	local blast_radius			= ability:GetLevelSpecialValueFor("blast_radius", ability_level)
	local knockback_distance 	= ability:GetLevelSpecialValueFor("knockback_distance", ability_level)
	local knockback_duration	= ability:GetLevelSpecialValueFor("knockback_duration", ability_level)

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
	dummy:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	dummy:OnPhysicsFrame(
		function()
			dummy:SetForwardVector(dummy:GetPhysicsVelocity())
			ParticleManager:SetParticleControl(particle, 3, dummy:GetAbsOrigin())

			if (dummy:GetAbsOrigin() - caster_location):Length2D() >= direction:Length2D() then
				
				local push_start_point = dummy:GetAbsOrigin()
				local push_end_point = (- blast_radius * (caster_location - push_start_point):Normalized()) + push_start_point
				dummy:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle)

				local explosion = ParticleManager:CreateParticle(particle_explosion, PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(explosion, 0, push_start_point)

				
				
				local units = FindUnitsInRadius(caster:GetTeamNumber(), push_start_point, nil, 2 * blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, unit in ipairs(units) do

					if (unit:GetAbsOrigin() - push_start_point):Length2D() < blast_radius then

						local knockback_table = 
						{
							should_stun = 0,
							knockback_duration = knockback_duration,
							duration = knockback_duration,
							knockback_distance = knockback_distance,
							knockback_height = 50,
							center_x = push_start_point.x,
							center_y = push_start_point.y,
							center_z = push_start_point.z
						}

						unit:AddNewModifier(caster, nil, "modifier_knockback", knockback_table)
					elseif (unit:GetAbsOrigin() - push_start_point):Length2D() > blast_radius and (unit:GetAbsOrigin() - push_start_point):Length2D() < 2 * blast_radius then

						local knockback_table = 
						{
							should_stun = 0,
							knockback_duration = knockback_duration,
							duration = knockback_duration,
							knockback_distance = knockback_distance / 2,
							knockback_height = 50,
							center_x = push_start_point.x,
							center_y = push_start_point.y,
							center_z = push_start_point.z
						}

						unit:AddNewModifier(caster, nil, "modifier_knockback", knockback_table)
					end
				end
			end
		end
	)
end