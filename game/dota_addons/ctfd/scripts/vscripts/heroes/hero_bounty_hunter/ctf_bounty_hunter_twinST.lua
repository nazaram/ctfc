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
	
	local target_points 	= keys.target_points[1] --target point prime
	local direction 		= target_points - caster_location
	

	ability.star_speed		= ability:GetLevelSpecialValueFor("star_speed", ability_level - 1)

	local dummy_unit_alpha	= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	local dummy_unit_beta	= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())

	local theta				= 15 * math.pi / 180 -- 15 degrees in radians

	local unit_zero_vector	= Vector(math.cos(0), math.sin(0)):Normalized()
	-- Target Point Alpha: 
	local direction_alpha	= Vector(direction:Length2D() * math.cos(theta), direction:Length2D() * math.sin(theta), direction.z)
	local alpha_point		= (direction:Normalized() + direction_alpha:Normalized()) * direction:Length2D()

	local direction_beta	= Vector(direction:Length2D() * math.cos(-1 * theta), direction:Length2D() * math.sin(-1 * theta), direction.z)
	local beta_point		= (direction:Normalized() + direction_beta:Normalized()) * direction:Length2D()


	local answer			= math.acos(DOT(caster:GetForwardVector(), unit_zero_vector) / caster:GetForwardVector():Normalized() * unit_zero_vector)

	print(math.deg(answer))

	-- local dotA = direction_alpha:Normalized() * direction:Normalized() * math.cos(theta)
	-- local dotB = direction_beta:Normalized() * direction:Normalized() * math.cos(-1 * theta)

	-- print("Alpha dot direction = ", dotA)
	-- print("Beta dot direction = ", dotB)

	-- dummy_unit_alpha:SetAbilityPoints(1)
	-- dummy_unit_alpha:FindAbilityByName("dummy_passive"):SetLevel(1)

	-- dummy_unit_beta:SetAbilityPoints(1)
	-- dummy_unit_beta:FindAbilityByName("dummy_passive"):SetLevel(1)

	local particle_alpha	= ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, dummy_unit_alpha)
	local particle_beta		= ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, dummy_unit_beta)

	Physics:Unit(dummy_unit_alpha)
	Physics:Unit(dummy_unit_beta)

	dummy_unit_alpha:PreventDI(true)
	dummy_unit_alpha:SetAutoUnstuck(true)
	dummy_unit_alpha:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit_alpha:FollowNavMesh(false)
	dummy_unit_alpha:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit_alpha:SetPhysicsVelocity(ability.star_speed * alpha_point)
	dummy_unit_alpha:SetPhysicsFriction(0)
	dummy_unit_alpha:Hibernate(false)
	dummy_unit_alpha:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	dummy_unit_beta:PreventDI(true)
	dummy_unit_beta:SetAutoUnstuck(true)
	dummy_unit_beta:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_unit_beta:FollowNavMesh(false)
	dummy_unit_beta:SetPhysicsVelocityMax(ability.star_speed)
	dummy_unit_beta:SetPhysicsVelocity(ability.star_speed * beta_point)
	dummy_unit_beta:SetPhysicsFriction(0)
	dummy_unit_beta:Hibernate(false)
	dummy_unit_beta:SetGroundBehavior(PHYSICS_GROUND_LOCK)



	Timers:CreateTimer(3, 
		function()
			-- print("Hi Aram") Debug
			dummy_unit_alpha:RemoveSelf()
			dummy_unit_beta:RemoveSelf()
			ParticleManager:ReleaseParticleIndex(particle_alpha)
			ParticleManager:ReleaseParticleIndex(particle_beta)
		end
		)

	local dummyax = dummy_unit_alpha:GetPhysicsVelocity():Normalized().x
	local dummyay = dummy_unit_alpha:GetPhysicsVelocity():Normalized().y
	local dummyaz = dummy_unit_alpha:GetPhysicsVelocity():Normalized().z


	local dummybx = dummy_unit_beta:GetPhysicsVelocity():Normalized().x
	local dummyby = dummy_unit_beta:GetPhysicsVelocity():Normalized().y
	local dummybz = dummy_unit_beta:GetPhysicsVelocity():Normalized().z

	dummy_unit_alpha:OnPhysicsFrame(
		function(dummy_unit_alpha)
			dummy_unit_alpha:SetForwardVector(Vector(dummyax, dummyay, dummyaz) * ability.star_speed * (direction:Length2D() / max_distance))

			local distance_alpha = (caster_location - dummy_unit_alpha:GetAbsOrigin()):Length2D()
			
			if distance_alpha > max_distance then
				dummy_unit_alpha:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle_alpha)
				return nil
			end
		end
	)

	dummy_unit_beta:OnPhysicsFrame(
		function(dummy_unit_beta)
			dummy_unit_beta:SetForwardVector(Vector(dummybx, dummyby, dummybz) * ability.star_speed * (direction:Length2D() / max_distance))

			local distance_beta = (caster_location - dummy_unit_beta:GetAbsOrigin()):Length2D()

			if distance_beta > max_distance then
				dummy_unit_beta:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle_beta)
				return nil
			end
		end
	)	
end




















-- To do:
	--linear projectile as dummy unit
	--two linear projectiles at varying angles toward target points alpha and beta
	--update function to curve vector toward target point prime
