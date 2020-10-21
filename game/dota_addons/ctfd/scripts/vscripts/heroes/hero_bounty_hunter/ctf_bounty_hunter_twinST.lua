ctf_bounty_hunter_twinST = class({})

function DOT (a, b)
	return (a[1] * b[1]) + (a[2] * b[2]) + (a[3] * a[3])

end

function LaunchStars( keys )
	local caster 			= keys.caster
	local caster_location 	= caster:GetAbsOrigin()
	
	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1

	local particle_name 	= "particles/econ/items/bounty_hunter/bounty_hunter_shuriken_hidden/bounty_hunter_suriken_toss_hidden_hunter.vpcf"

	local max_distance		= ability:GetLevelSpecialValueFor("star_range", ability_level - 1)
	local target_prime 		= keys.target_points[1] --target point prime
	local direction_prime	= (target_prime - caster_location):Normalized()

	caster:SetForwardVector(direction_prime:Normalized())
	
	ability.star_speed		= ability:GetLevelSpecialValueFor("star_speed", ability_level - 1)

	local dummy_unit_prime 	= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	local dummy_unit_alpha	= CreateUnitByName("npc_dota_custom_dummy_unit", dummy_unit_prime:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	local dummy_unit_beta	= CreateUnitByName("npc_dota_custom_dummy_unit", dummy_unit_prime:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())

	local theta				= 45 * math.pi / 180 -- 15 degrees in radians
	local unit_zero_vector	= Vector(caster_location.x + math.cos(0), caster_location.y + math.sin(0), caster_location.z):Normalized() - caster_location:Normalized() -- NORTH

	-- dot product between vectors direction and unit_zero_vector in radians
	-- local angle_prime		= math.acos(DOT(caster:GetForwardVector():Normalized(), unit_zero_vector) / (caster:GetForwardVector():Normalized():Length2D() * unit_zero_vector:Length2D())) 

	-- Target Point Alpha: 
	local target_alpha 		= Vector(target_prime.x + direction_prime.x * math.cos(theta), target_prime.y + direction_prime.y * math.sin(theta))
	local direction_alpha	= (target_alpha - caster_location):Normalized()
	-- local angle_alpha		= math.acos(DOT(direction_alpha:Normalized(), unit_zero_vector) / (direction_alpha:Normalized():Length2D()))

	-- Target Point Beta:
	local target_beta		= Vector(target_prime.x + direction_prime.x * math.cos(theta), target_prime.y + direction_prime.y * math.sin(theta))
	local direction_beta	= (target_beta - caster_location):Normalized()
	-- local angle_beta		= math.acos(DOT(direction_beta:Normalized(), unit_zero_vector) / (direction_beta:Normalized():Length2D()))


	print("Target Alpha.X: ", target_alpha.x)
	print("Target Alpha.y: ", target_alpha.y)
	print("Target Alpha.z: ", target_alpha.z)

	print("Target Beta.X: ", target_beta.x)
	print("Target Beta.y: ", target_beta.y)
	print("Target Beta.z: ", target_beta.z)

	local particle_alpha	= ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, dummy_unit_alpha)
	local particle_beta		= ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, dummy_unit_beta)

	Physics:Unit(dummy_unit_prime)
	Physics:Unit(dummy_unit_alpha)
	Physics:Unit(dummy_unit_beta)

	dummy_unit_prime:PreventDI(true)
	dummy_unit_prime:SetAutoUnstuck(true)
	dummy_unit_prime:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit_prime:FollowNavMesh(false)
	dummy_unit_prime:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit_prime:SetPhysicsVelocity(ability.star_speed * direction_prime)
	dummy_unit_prime:SetPhysicsFriction(0)
	dummy_unit_prime:Hibernate(false)
	dummy_unit_prime:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	dummy_unit_alpha:PreventDI(true)
	dummy_unit_alpha:SetAutoUnstuck(true)
	dummy_unit_alpha:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit_alpha:FollowNavMesh(false)
	dummy_unit_alpha:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit_alpha:SetPhysicsVelocity(ability.star_speed * direction_alpha)
	dummy_unit_alpha:SetPhysicsFriction(0)
	dummy_unit_alpha:Hibernate(false)
	dummy_unit_alpha:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	dummy_unit_beta:PreventDI(true)
	dummy_unit_beta:SetAutoUnstuck(true)
	dummy_unit_beta:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit_beta:FollowNavMesh(false)
	dummy_unit_beta:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit_beta:SetPhysicsVelocity(ability.star_speed * direction_beta)
	dummy_unit_beta:SetPhysicsFriction(0)
	dummy_unit_beta:Hibernate(false)
	dummy_unit_beta:SetGroundBehavior(PHYSICS_GROUND_LOCK)



	Timers:CreateTimer(3, 
		function()
			-- print("Hi Aram") Debug
			dummy_unit_prime:RemoveSelf()
			dummy_unit_alpha:RemoveSelf()
			dummy_unit_beta:RemoveSelf()

			ParticleManager:ReleaseParticleIndex(particle_alpha)
			ParticleManager:ReleaseParticleIndex(particle_beta)
		end
		)

	local dummypx = dummy_unit_prime:GetPhysicsVelocity():Normalized().x
	local dummypy = dummy_unit_prime:GetPhysicsVelocity():Normalized().y
	local dummypz = dummy_unit_prime:GetPhysicsVelocity():Normalized().z

	local dummyax = dummy_unit_alpha:GetPhysicsVelocity():Normalized().x
	local dummyay = dummy_unit_alpha:GetPhysicsVelocity():Normalized().y
	local dummyaz = dummy_unit_alpha:GetPhysicsVelocity():Normalized().z

	local dummybx = dummy_unit_beta:GetPhysicsVelocity():Normalized().x
	local dummyby = dummy_unit_beta:GetPhysicsVelocity():Normalized().y
	local dummybz = dummy_unit_beta:GetPhysicsVelocity():Normalized().z


	dummy_unit_prime:OnPhysicsFrame(
		function(dummy_unit_prime)
			dummy_unit_prime:SetForwardVector(Vector(dummypx, dummypy, dummpz) * ability.star_speed * (direction_prime:Length2D() / max_distance))
		end
	)

	dummy_unit_alpha:OnPhysicsFrame(
		function(dummy_unit_alpha)
			dummy_unit_alpha:SetForwardVector(Vector(dummyax, dummyay, dummyaz) * ability.star_speed * (direction_alpha:Length2D() / max_distance))
			--ParticleManager:SetParticleControl(particle_alpha, 1, dummy_unit_alpha:GetForwardVector())

			local distance_alpha = (caster_location - dummy_unit_alpha:GetAbsOrigin()):Length2D()
			
			-- if distance_alpha > max_distance then
			-- 	dummy_unit_alpha:RemoveSelf()
			-- 	ParticleManager:ReleaseParticleIndex(particle_alpha)
			-- 	return nil
			-- end
		end
	)

	dummy_unit_beta:OnPhysicsFrame(
		function(dummy_unit_beta)
			dummy_unit_beta:SetForwardVector(Vector(dummybx, dummyby, dummybz) * ability.star_speed * (direction_beta:Length2D() / max_distance))

			local distance_beta = (caster_location - dummy_unit_beta:GetAbsOrigin()):Length2D()

			-- if distance_beta > max_distance then
			-- 	dummy_unit_beta:RemoveSelf()
			-- 	ParticleManager:ReleaseParticleIndex(particle_beta)
			-- 	return nil
			-- end
		end
	)	
end




















-- To do:
	--linear projectile as dummy unit
	--two linear projectiles at varying angles toward target points alpha and beta
	--update function to curve vector toward target point prime
