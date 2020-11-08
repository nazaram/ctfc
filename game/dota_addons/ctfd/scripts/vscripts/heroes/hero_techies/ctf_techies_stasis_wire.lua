ctf_techies_stasis_wire = class ({})

function OnSpellStart( keys )
	local statis_model			= "models/heroes/techies/fx_techiesfx_stasis.vmdl"
	local particle_plant		= "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf"

	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()
	local target_point	 		= keys.target_points[1]

	local direction 			= (target_point - caster_location):Normalized()
	local distance				= (target_point - caster_location):Length2D()

	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local setup_delay 			= ability:GetLevelSpecialValueFor("setup_delay", ability_level)
	local placement_distance	= ability:GetLevelSpecialValueFor("placement_distance", ability_level)

	-- if dummy_c == nil and dummy_t == nil then

	-- 	dummy_c					= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location + placement_distance * GetForwardVector():Normalized, true, caster, caster, caster:GetTeamNumber())
	-- 	dummy_t					= CreateUnitByName("npc_dota_custom_dummy_unit", target_point, true, caster, caster, caster:GetTeamNumber())

	-- else
	-- 	dummy_c:RemoveSelf()
	-- 	dummy_t:RemoveSelf()

	-- 	dummy_c					= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location + placement_distance * GetForwardVector(), true, caster, caster, caster:GetTeamNumber())
	-- 	dummy_t					= CreateUnitByName("npc_dota_custom_dummy_unit", target_point, true, caster, caster, caster:GetTeamNumber())

	-- end

	local plant_fx = ParticleManager:CreateParticle(particle_plant, PATTACH_ABSORIGIN, caster)

	print("particles")

	ParticleManager:SetParticleControl(plant_fx, 0, target_point)
	ParticleManager:SetParticleControl(plant_fx, 1, target_point)

	local dummy_stasis = CreateUnitByName("npc_dota_custom_dummy_unit", target_point, caster, caster, caster:GetTeam())
	dummy_stasis:SetOriginalModel(statis_model)
	dummy_stasis:SetModel(statis_model)

	Physics:Unit(dummy_stasis)

	dummy:PreventDI(true)
	dummy:SetAutoUnstuck(true)
	dummy:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy:FollowNavMesh(false)
	dummy:SetPhysicsVelocityMax(0)
	dummy:SetPhysicsVelocity(0)
	dummy:SetPhysicsFriction(0)
	dummy:Hibernate(false)
	dummy:SetGroundBehavior(PHYSICS_GROUND_LOCK)
end