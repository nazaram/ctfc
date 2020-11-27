ctf_orb = class({})

function OnUpgrade( keys )
	local caster 				= keys.caster
	local sub_ability_name 		= "puck_jaunt_ctf"
	local sub_ability 			= caster:FindAbilityByName(sub_ability_name)

	sub_ability:SetLevel(1)
	sub_ability:UpgradeAbility(true)
	sub_ability:SetActivated(true)
end

function OnSpellStart( keys )
	local particle_orb			= "particles/units/heroes/hero_puck/puck_illusory_orb_main.vpcf"

	local main_ability_name 	= "puck_illusory_orb_ctf"
	local sub_ability_name 		= "puck_jaunt_ctf"
	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()

	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local orb_speed 			= ability:GetLevelSpecialValueFor("orb_speed", ability_level)
	local max_range 			= ability:GetLevelSpecialValueFor("max_range", ability_level)

	local target_point	 		= keys.target_points[1]

	local direction 			= (target_point - caster_location):Normalized()

	dummy_orb					= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	dummy_orb:AddNewModifier(dummy_orb, nil, "modifier_no_healthbar", {duration = -1})

	local orb_fx				= ParticleManager:CreateParticle(particle_orb, PATTACH_ABSORIGIN, dummy_orb)

	caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

	Physics:Unit(dummy_orb)

	dummy_orb:PreventDI(true)
	dummy_orb:SetAutoUnstuck(true)
	dummy_orb:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_orb:FollowNavMesh(false)
	dummy_orb:SetPhysicsVelocityMax(orb_speed)
	dummy_orb:SetPhysicsVelocity(orb_speed * direction)
	dummy_orb:SetPhysicsFriction(0)
	dummy_orb:Hibernate(false)
	dummy_orb:SetGroundBehavior(PHYSICS_GROUND_LOCK)

	dummy_orb:OnPhysicsFrame(
		function()
			local progress = (dummy_orb:GetAbsOrigin() - caster_location):Length2D()

			dummy_orb:SetForwardVector(dummy_orb:GetPhysicsVelocity())
			ParticleManager:SetParticleControl(orb_fx, 3, dummy_orb:GetAbsOrigin())

			if progress >= max_range then
				caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)
				dummy_orb:RemoveSelf()
			end
		end
	)
end

function Jump( keys )
	local main_ability_name 	= "puck_illusory_orb_ctf"
	local sub_ability_name 		= "puck_jaunt_ctf"

	local caster 				= keys.caster
	local ability 				= caster:FindAbilityByName(main_ability_name)
	local ability_level 		= ability:GetLevel() - 1

	local dummy_pos				= dummy_orb:GetAbsOrigin()

	caster:SwapAbilities(main_ability_name, sub_ability_name, true, false)

	FindClearSpaceForUnit(caster, dummy_orb:GetAbsOrigin(), true)

	dummy_orb:RemoveSelf()
end