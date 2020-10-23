ctf_bounty_hunter_twinST = class({})

function DOT (a, b)
	return (a[1] * b[1]) + (a[2] * b[2]) + (a[3] * a[3])

end

function LaunchStars( keys )
	local caster 			= keys.caster
	local caster_location 	= caster:GetAbsOrigin()
	
	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1

	local particle_name 	= "particles/units/heroes/hero_bounty_hunter/bounty_hunter_shuriken_toss_main.vpcf"

	local max_distance		= ability:GetLevelSpecialValueFor("star_range", ability_level - 1)
	local search_radius		= ability:GetLevelSpecialValueFor("star_width", ability_level - 1)
	local target_prime 		= keys.target_points[1] --target point prime
	local direction_prime	= (target_prime - caster_location):Normalized()

	caster:SetForwardVector(direction_prime:Normalized())
	
	ability.star_speed		= ability:GetLevelSpecialValueFor("star_speed", ability_level - 1)

	local dummy_unit_prime 	= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	local dummy_unit_alpha	= CreateUnitByName("npc_dota_custom_dummy_unit", dummy_unit_prime:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	local dummy_unit_beta	= CreateUnitByName("npc_dota_custom_dummy_unit", dummy_unit_prime:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())

	dummy_unit_prime:AddNewModifier(dummy_unit_prime, nil, "modifier_no_healthbar", {duration = -1})
	dummy_unit_alpha:AddNewModifier(dummy_unit_alpha, nil, "modifier_no_healthbar", {duration = -1})
	dummy_unit_beta:AddNewModifier(dummy_unit_beta, nil, "modifier_no_healthbar", {duration = -1})


	local theta				= 30 -- degrees in radians
	local unit_zero_vector	= Vector(caster_location.x + math.cos(0), caster_location.y + math.sin(0), caster_location.z):Normalized() - caster_location:Normalized() -- NORTH

	-- Target Point Alpha: 
	--Rotate one global point around another global point
	-- local target_alpha		= RotatePosition(caster_location, QAngle(0, theta, 0), target_prime)
	-- local direction_alpha	= (target_alpha - caster_location):Normalized()
	local direction_alpha 	= RotatePosition(Vector(0, 0, 0), QAngle(0, theta, 0), direction_prime)

	
	-- Target Point Beta:
	-- local target_beta		= RotatePosition(caster_location, QAngle(0, -theta, 0), target_prime)
	-- local direction_beta	= (target_beta - caster_location):Normalized()
	local direction_beta 	= RotatePosition(Vector(0, 0, 0), QAngle(0, -theta, 0), direction_prime)

	local particle_alpha	= ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, dummy_unit_alpha)
	local particle_beta		= ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, dummy_unit_beta)

	
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

	local dummyp_dis = 0
	local dummya_dis = 0
	local dummyb_dis = 0

	dummy_unit_prime:OnPhysicsFrame(
		function()
			dummy_unit_prime:SetForwardVector(dummy_unit_prime:GetPhysicsVelocity())

			dummyp_dis = (dummy_unit_prime:GetAbsOrigin() - caster_location):Length2D()

			if dummyp_dis > max_distance + 250 then
				dummy_unit_prime:RemoveSelf()
			end
		end
	)

	dummy_unit_alpha:OnPhysicsFrame(
		function()
			dummy_unit_alpha:SetForwardVector(dummy_unit_alpha:GetPhysicsVelocity())

			dummya_dis = (dummy_unit_alpha:GetAbsOrigin() - caster_location):Length2D()

			ParticleManager:SetParticleControl(particle_alpha, 3, Vector(dummy_unit_alpha:GetAbsOrigin().x, dummy_unit_alpha:GetAbsOrigin().y, dummy_unit_alpha:GetAbsOrigin().z + 50))

			dummy_unit_alpha:SetPhysicsVelocity(dummy_unit_alpha:GetPhysicsVelocity() + 0.2 * (dummy_unit_prime:GetAbsOrigin() - dummy_unit_alpha:GetAbsOrigin()))


			if dummy_unit_alpha ~= nil then
				Timers:CreateTimer(
					function()
						local units = FindUnitsInRadius(
						caster:GetTeam(), 
						dummy_unit_alpha:GetAbsOrigin(), 
						nil,
						radius, 
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO, 
						DOTA_UNIT_TARGET_FLAG_NONE,
						FIND_CLOSEST,
						false)

						for _, unit in ipairs(units) do
							if ((unit:GetAbsOrigin() - dummy_unit_alpha:GetAbsOrigin()):Length2D()) < radius then
								dummy_unit_alpha:RemoveSelf()
								ParticleManager:ReleaseParticleIndex(particle_alpha)				
							end
						end

						return 0.25
					end
				)
			end

			if dummya_dis > max_distance then
				dummy_unit_alpha:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle_alpha)
			end

		end
	)

	dummy_unit_beta:OnPhysicsFrame(
		function()
			dummy_unit_beta:SetForwardVector(dummy_unit_beta:GetPhysicsVelocity())
			
			dummyb_dis = (dummy_unit_beta:GetAbsOrigin() - caster_location):Length2D()

			ParticleManager:SetParticleControl(particle_beta, 3, Vector(dummy_unit_beta:GetAbsOrigin().x, dummy_unit_beta:GetAbsOrigin().y, dummy_unit_beta:GetAbsOrigin().z + 50))

			dummy_unit_beta:SetPhysicsVelocity(dummy_unit_beta:GetPhysicsVelocity() + 0.2 * (dummy_unit_prime:GetAbsOrigin() - dummy_unit_beta:GetAbsOrigin()))
			
			if dummy_unit_beta ~= nil then
				Timers:CreateTimer(
					function()
						local units = FindUnitsInRadius(
						caster:GetTeam(), 
						dummy_unit_beta:GetAbsOrigin(), 
						nil,
						radius, 
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO, 
						DOTA_UNIT_TARGET_FLAG_NONE,
						FIND_CLOSEST,
						false)

						for _, unit in ipairs(units) do
							if ((unit:GetAbsOrigin() - dummy_unit_beta:GetAbsOrigin()):Length2D()) < radius then
								dummy_unit_beta:RemoveSelf()
								ParticleManager:ReleaseParticleIndex(particle_beta)				
							end
						end

						return 0.25
					end
				)
			end

			if dummyb_dis > max_distance then
				dummy_unit_beta:RemoveSelf()
				ParticleManager:ReleaseParticleIndex(particle_beta)
			end
		end
	)	
end




















-- To do:
	--linear projectile as dummy unit
	--two linear projectiles at varying angles toward target points alpha and beta
	--update function to curve vector toward target point prime
