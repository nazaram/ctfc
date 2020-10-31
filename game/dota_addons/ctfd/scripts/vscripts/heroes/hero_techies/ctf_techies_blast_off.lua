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

	local dummy				= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	local mine_model		= "models/heroes/techies/fx_techiesfx_mine.vmdl"

	dummy:SetModel("models/heroes/techies/fx_techiesfx_mine.vmdl")
	Physics:Unit(dummy)

	dummy:PreventDI(true)
	dummy:SetAutoUnstuck(true)
	dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy:FollowNavMesh(false)
	dummy:SetPhysicsVelocityMax()
	dummy:SetPhysicsVelocity()
	dummy:SetPhysicsFriction(0)
	dummy:Hibernate(false)
	dummy:SetGroundBehavior(PHYSICS_GROUND_NOTHING)

	dummy:OnPhysicsFrame(
		function()
			
	)
end