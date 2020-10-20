ctf_bounty_hunter_twinST = class({})

function LaunchStars( keys )
	local caster 			= keys.caster
	local caster_location 	= caster:GetAbsOrigin()
	
	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1
	local particle_name 	= "particles/econ/items/bounty_hunter/bounty_hunter_shuriken_hidden/bounty_hunter_suriken_toss_hidden_hunter.vpcf"
	local max_distance		= ability:GetLevelSpecialValueFor("star_range", ability_level - 1)
	

	local target_points 	= keys.target_points[1] --target point prime
	local direction 		= (target_points - caster_location):Normalized()
	local direction_alpha	= direction + 

	ability.star_speed		= ability:GetLevelSpecialValueFor("star_speed", ability_level - 1)

	local dummy_unit_alpha	= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	local dummy_unit_beta	= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())

	--dummy_unit_alpha:SetAbilityPoints(1)
	dummy_unit_alpha:FindAbilityByName("dummy_passive"):SetLevel(1)

	local particle_alpha	= ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, dummy_unit_alpha)

	Physics:Unit(dummy_unit_alpha)

	dummy_unit_alpha:PreventDI(true)
	dummy_unit_alpha:SetAutoUnstuck(false)
	dummy_unit_alpha:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit_alpha:FollowNavMesh(false)
	dummy_unit_alpha:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit_alpha:SetPhysicsVelocity(ability.star_speed * direction)
	dummy_unit_alpha:SetPhysicsFriction(0)
	dummy_unit_alpha:Hibernate(false)
	dummy_unit_alpha:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	Timers:CreateTimer(3, 
		function()
			-- print("Hi Aram") Debug
			dummy_unit_alpha:RemoveSelf()
			ParticleManager:ReleaseParticleIndex(particle_alpha)
		end
		)

	local dummyx = dummy_unit_alpha:GetPhysicsVelocity():Normalized().x
	local dummyy = dummy_unit_alpha:GetPhysicsVelocity():Normalized().y
	local dummyz = dummy_unit_alpha:GetPhysicsVelocity():Normalized().z

	dummy_unit_alpha:OnPhysicsFrame(
		function(dummy_unit_alpha)
			dummy_unit_alpha:SetForwardVector(Vector(dummyx, dummyy, dummyz) * 0.1 * ability.star_speed)

			local distance = (caster_location - dummy_unit_alpha:GetAbsOrigin()):Length2D()
			
			if distance > max_distance then
				dummy_unit_alpha:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle_alpha)
				return nil
			end
		end
		)	
end




















-- To do:
	--linear projectile as dummy unit
	--two linear projectiles at varying angles toward target points alpha and beta
	--update function to curve vector toward target point prime
