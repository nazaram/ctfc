ctf_techies_blast_off = class({})

function OnSpellStart( keys )


	local particle_trail 	= "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"

	local caster 			= keys.caster
	local caster_location 	= caster:GetAbsOrigin()

	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel()

	local radius 			= ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage 			= ability:GetLevelSpecialValueFor("damage", ability_level)
	local leap_duration 	= ability:GetLevelSpecialValueFor("leap_duration", ability_level)
	local leap_max_height 	= ability:GetLevelSpecialValueFor("leap_max_height", ability_level)

	local target_point	 	= keys.target_points[1]

	-- local trail_fx			= 0

	local direction 		= (target_point - caster_location):Normalized()
	local distance			= (target_point - caster_location):Length2D()

	local velocity_h		= direction * distance / leap_duration

	Physics:Unit(caster)

	caster:PreventDI(true)
	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	caster:FollowNavMesh(false)
	caster:SetPhysicsVelocityMax(velocity_h:Length2D())
	caster:SetPhysicsVelocity(velocity_h)
	caster:SetPhysicsFriction(0)
	caster:Hibernate(false)
	caster:SetGroundBehavior(PHYSICS_GROUND_NOTHING)

	caster:OnPhysicsFrame(
		function()
			
			local rho = (caster:GetAbsOrigin() - caster_location):Length2D() / distance

			local vel = Vector(caster:GetPhysicsVelocity().x, caster:GetPhysicsVelocity().y, caster:GetPhysicsVelocity().z)

			if (caster:GetAbsOrigin() - caster_location):Length2D() <= distance then
				caster:SetForwardVector(caster:GetPhysicsVelocity())
			
			else 		
				caster:PreventDI(false)
				FindClearSpaceForUnit( caster, target_point, true )
				caster:StopPhysicsSimulation()
			end

		end
	)
end