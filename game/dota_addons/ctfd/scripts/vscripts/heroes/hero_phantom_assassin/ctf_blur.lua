LinkLuaModifier("modifier_blur_map_vanish", "heroes/hero_phantom_assassin/ctf_blur.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blur_proper_vanish", "heroes/hero_phantom_assassin/ctf_blur.lua", LUA_MODIFIER_MOTION_NONE)

ctf_blur = class({})

function OnUpgrade( keys )
	local caster 				= keys.caster

	caster:AddNewModifier(caster, nil, "modifier_blur_map_vanish", {duration = -1})
end

function OnSpellStart( keys )
	local caster 				= keys.caster

	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local vanish_dispel_delay 	= ability:GetLevelSpecialValueFor("vanish_dispel_delay", ability_level)
	local vanish_dispel_radius 	= ability:GetLevelSpecialValueFor("vanish_dispel_radius", ability_level)
	local vanish_duration 		= ability:GetLevelSpecialValueFor("vanish_duration", ability_level)

	caster:AddNewModifier(caster, nil, "modifier_blur_proper_vanish", {duration = vanish_duration})
	--caster:AddNewModifier(caster, nil, "modifier_invisible", {duration = vanish_duration})

	Timers:CreateTimer(vanish_dispel_delay,
		function()
			local units = FindUnitsInRadius(
				caster:GetTeam(),
				caster:GetAbsOrigin(),
				nil,
				vanish_dispel_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				true)

			for _, unit in ipairs(units) do
				if (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() < vanish_dispel_radius then
					caster:RemoveModifierByName("modifier_blur_proper_vanish")
				end
			end

			return 0.25
		end
	)
end

modifier_blur_map_vanish = class({})

function modifier_blur_map_vanish:IsPassive()
	return true
end

function modifier_blur_map_vanish:IsHidden()
	return false
end

function modifier_blur_map_vanish:IsDebuff()
	return false
end

function modifier_blur_map_vanish:IsPurgable()
	return false
end

function modifier_blur_map_vanish:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true
	}

	return state
end

modifier_blur_proper_vanish = class({})

function modifier_blur_proper_vanish:IsHidden()
	return false
end

function modifier_blur_proper_vanish:IsDebuff()
	return false
end

function modifier_blur_proper_vanish:IsPurgable()
	return false
end

function modifier_blur_proper_vanish:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
end

function modifier_blur_proper_vanish:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_blur_proper_vanish:GetTexture()
	return "phantom_assassin_blur"
end

function modifier_blur_proper_vanish:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}

	return funcs
end

-- this is purely for visuals ( the "half disappeared" effect )
function modifier_blur_proper_vanish:GetModifierInvisibilityLevel()
	return 0.5
end


function modifier_blur_proper_vanish:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}

	return state
end