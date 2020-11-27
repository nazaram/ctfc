LinkLuaModifier("modifier_phased", "heroes/hero_puck/ctf_phase_coil.lua", LUA_MODIFIER_MOTION_NONE)

ctf_phase_coil = class({})

function OnSpellStart( keys )

	local phase_mod = "modifier_phased"

	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()

	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local channel_duration = ability:GetLevelSpecialValueFor("channel_duration", ability_level)

	caster:AddNewModifier(caster, nil, "FindModifierByName", {duration = channel_duration})
	caster:AddNoDraw()
end

function OnChannelFinish( keys )
	local phase_mod = "modifier_phased"

	local caster = keys.caster

	if caster:FindModifierByName(phase_mod) == phase_mod then
		caster:RemoveModifierByName(phase_mod)
		caster:RemoveNoDraw()
	end
end

modifier_phased = class({})

function modifier_phased:IsHidden()
	return true
end

function modifier_phased:IsDebuff()
	return false
end

function modifier_phased:IsPurgable()
	return false
end

function modifier_phased:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

-- function modifier_phased:DeclarFunctions()
-- 	local funcs = {
-- 		 MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
-- 	}
-- 	return funcs
-- end

-- function modifier_phased:OnAbilityEndChannel( keys )
-- 	keys.caster:RemoveModifierByName(modifier_phased)
-- 	keys.caster:RemoveNoDraw()
-- end