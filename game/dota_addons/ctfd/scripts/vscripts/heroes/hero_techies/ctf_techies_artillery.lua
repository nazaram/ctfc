LinkLuaModifier("modifier_charges", "libraries/modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE)

ctf_techies_artillery = class({})

function OnUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability

	local stacks = caster:FindModifierByName("modifier_charges")

	if caster:HasModifier("modifier_charges") then -- Check how many stackes techies has and adds one
		caster:RemoveModifierByName("modifier_charges")
		caster:AddNewModifier(caster, ability, "modifier_charges", {
			max_count = ability:GetLevelSpecialValueFor("max_charges", ability:GetLevel() - 1),
			start_count = stacks:GetStackCount() + 1,
			replenish_time = ability:GetLevelSpecialValueFor("charge_restore_time", ability:GetLevel() - 1)
		})

		ability:EndCooldown()
	else -- First ability level give max charges
		caster:AddNewModifier(caster, ability, "modifier_charges", {
			max_count = ability:GetLevelSpecialValueFor("max_charges", ability:GetLevel() - 1),
			replenish_time = ability:GetLevelSpecialValueFor("charge_restore_time", ability:GetLevel() - 1)
		})
	end 
end

function OnSpellStart( keys )
	local particle_name			= "particles/units/heroes/hero_techies/techies_base_attack_model.vpcf"
	local particle_trail		= "particles/units/heroes/hero_techies/techies_base_attack_trail_c.vpcf"
	local particle_explosion	= "particles/units/heroes/hero_techies/techies_land_mine_ball_explosion.vpcf"
	local sound_fire			= "Hero_Techies.LandMine.Plant"
	local sound_explosion	 	= "Hero_Techies.LandMine.Detonate"

	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()
	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local shell_speed			= ability:GetLevelSpecialValueFor("shell_speed", ability_level)
	local min_distance			= ability:GetLevelSpecialValueFor("min_distance", ability_level)
	local blast_radius			= ability:GetLevelSpecialValueFor("blast_radius", ability_level)
	local knockback_distance 	= ability:GetLevelSpecialValueFor("knockback_distance", ability_level)
	local knockback_duration	= ability:GetLevelSpecialValueFor("knockback_duration", ability_level)
	local shell_height_max		= ability:GetLevelSpecialValueFor("shell_height", ability_level)

	local target_point			= keys.target_points[1]
	local direction 			= target_point - caster_location

	if direction:Length2D() < min_distance then
		direction = min_distance * direction:Normalized()
	end

	local distance 				= direction:Length2D()

	local dummy					= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	dummy:AddNewModifier(dummy, nil, "modifier_no_healthbar", {duration = -1})
	local particle 				= ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, dummy)
	local trail_fx				= ParticleManager:CreateParticle(particle_trail, PATTACH_ABSORIGIN, dummy)

	caster:EmitSound(sound_fire)

	Physics:Unit(dummy)

	dummy:PreventDI(true)
	dummy:SetAutoUnstuck(true)
	dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy:FollowNavMesh(false)
	dummy:SetPhysicsVelocityMax(shell_speed)
	dummy:SetPhysicsVelocity(shell_speed * direction)
	dummy:SetPhysicsFriction(0)
	dummy:Hibernate(false)
	dummy:SetGroundBehavior(PHYSICS_GROUND_NOTHING)


	if not GameRules:IsGamePaused() then
		dummy:OnPhysicsFrame(
			function()

				local rho = (dummy:GetAbsOrigin() - caster_location):Length2D() / distance -- get ratio of horizantal travel between distance (dummy and caster) / full cast distance

				dummy:SetForwardVector(dummy:GetPhysicsVelocity())
				ParticleManager:SetParticleControl(particle, 3, Vector(dummy:GetAbsOrigin().x, dummy:GetAbsOrigin().y, dummy:GetAbsOrigin().z + (rho - rho * rho) * shell_height_max))
				ParticleManager:SetParticleControl(trail_fx, 3, Vector(dummy:GetAbsOrigin().x, dummy:GetAbsOrigin().y, dummy:GetAbsOrigin().z + (rho - rho * rho) * shell_height_max))

				if (dummy:GetAbsOrigin() - caster_location):Length2D() >= direction:Length2D() then
					local push_start_point = dummy:GetAbsOrigin()
					dummy:EmitSound(sound_explosion)
					
					dummy:RemoveSelf()
					ParticleManager:ReleaseParticleIndex(particle)
					ParticleManager:ReleaseParticleIndex(trail_fx)

					local explosion = ParticleManager:CreateParticle(particle_explosion, PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl(explosion, 0, push_start_point)
					
					GridNav:DestroyTreesAroundPoint(push_start_point, 0.25 * blast_radius, true)

					local units = FindUnitsInRadius(caster:GetTeamNumber(), push_start_point, nil, blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

					for _, unit in ipairs(units) do

						if (unit:GetAbsOrigin() - push_start_point):Length2D() < blast_radius / 2 then

							local knockback_table = 
							{
								should_stun = 0,
								knockback_duration = knockback_duration,
								duration = knockback_duration,
								knockback_distance = 2 * knockback_distance,
								knockback_height = 50,
								center_x = push_start_point.x,
								center_y = push_start_point.y,
								center_z = push_start_point.z
							}

							unit:AddNewModifier(caster, nil, "modifier_knockback", knockback_table)
						elseif (unit:GetAbsOrigin() - push_start_point):Length2D() > blast_radius / 2 and (unit:GetAbsOrigin() - push_start_point):Length2D() <= blast_radius then

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
						end
					end
				end
			end
		)
	end	
end