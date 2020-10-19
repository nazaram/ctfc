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

	ability.star_speed		= ability:GetLevelSpecialValueFor("star_speed", ability_level - 1)

	local dummy_unit		= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())

	--dummy_unit:SetAbilityPoints(1)
	dummy_unit:FindAbilityByName("dummy_passive"):SetLevel(1)

	local particle 			= ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, dummy_unit)

	Physics:Unit(dummy_unit)

	dummy_unit:PreventDI(true)
	dummy_unit:SetAutoUnstuck(false)
	dummy_unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit:FollowNavMesh(false)
	dummy_unit:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit:SetPhysicsVelocity(ability.star_speed * direction)
	dummy_unit:SetPhysicsFriction(0)
	dummy_unit:Hibernate(false)
	dummy_unit:SetGroundBehavior(PHYSICS_GROUND_LOCK)


	dummy_unit:OnPhysicsFrame(
		function(dummy_unit)
			dummy_unit:SetForwardVector((dummy_unit:GetPhysicsVelocity()):Normalized() * 0.1 * ability.star_speed)

			local distance = (caster_location - dummy_unit:GetAbsOrigin()):Length2D()
			
			if distance > max_distance then
				dummy_unit:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle)
				return nil
			end
		end
		)	
end




















-- To do:
	--linear projectile as dummy unit
	--two linear projectiles at varying angles toward target points alpha and beta
	--update function to curve vector toward target point prime
