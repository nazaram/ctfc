ctf_pudge_lil_stinky.lua = class({})

LinkLuaModifer( "modifier_lil_stinky_slow", "heroes/ctf_pudge_lil_stinky.lua", LUA_MODIFIER_MOTION_NONE )

local caster 				= keys.caster
local caster_location		= caster:GetAbsOrigin()
local ability 				= keys.ability
ability.level 				= ability:GetLevel()
local radius 				= ability:GetLevelSpecialValueFor("radius", ability.level - 1)
local slow 					= ability:GetLevelSpecialValueFor("movespeed_slow", ability.level - 1)
local duration 				= ability:GetLevelSpecialValueFor("duration", ability.level - 1)

local particle_name1 = "particles/econ/items/pudge/pudge_tassles_of_black_death/dcpudge_rot_flies.vpcf"
local particle_name2 = "particles/units/heroes/hero_pudge/pudge_rot.vpcf"
local particle_name3 = "particles/units/heroes/hero_pudge/pudge_rot_body_decay_2.vpcf"

function SlowHeroes ( keys )
	local dummy = CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster:GetTeamNumber())
	local units = FindUnitsInRadius(
		caster:GetTeam(), 
		caster_location, 
		nil, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		true)

	local particle1 = ParticleManager:CreateParticle(particle_name1, PATTACH_WORLDORIGIN, caster)
	local particle2 = ParticleManager:CreateParticle(particle_name2, PATTACH_WORLDORIGIN, caster)
	local particle3 = ParticleManager:CreateParticle(particle_name3, PATTACH_WORLDORIGIN, caster)


	for _, unit in ipairs(units) do

		if ((unit:GetAbsOrigin() - dummy:GetAbsOrigin()):Length2D()) < radius then
			unit:AddNewModifier(caster, ability, "modifier_lil_stinky_slow", {duration = duration})
		else
			unit:RemoveModifierByName("modifier_lil_stinky_slow")
		end
	end

	-- After duration seconds destory dummy rot unit
	Timers:CreateTimer(duration,
			function()
				dummy:RemoveSElf()

				ParticleManager:DestroyParticle(particle1)
				ParticleManager:DestroyParticle(particle2)
				ParticleManager:DestroyParticle(particle3)
			end
		)



end

modifier_lil_stinky_slow = class({})

function modifier_lil_stinky_slow:isHidden()
	return false
end

function modifier_lil_stinky_slow:IsDebuff()
	return true
end

function modifier_lil_stinky_slow:IsPurgable()
	return false
end

function modifier_lil_stinky_slow:GetEffectName()
	return "particles/units/heroes/hero_pudge/pudge_rot_body_spores.vpcf"
end

function modifier_lil_stinky_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_lil_stinky_slow:GetTexture()
	return "pudge_rot"
end

function modifier_lil_stinky_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_lil_stinky_slow:GetModifierMoveSpeedBonus_Percentage()
	return slow
end