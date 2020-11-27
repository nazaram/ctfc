LinkLuaModifier("modifier_storm_silence", "heroes/hero_disruptor/ctf_static_storm.lua", LUA_MODIFIER_MOTION_NONE)

ctf_statis_storm = class({})

function OnSpellStart( keys )
	local particle_storm	= "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf"

	local sound_cast		= "Hero_Disruptor.StaticStorm.Cast"

	local caster 			= keys.caster

	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1

	local storm_radius		= ability:GetLevelSpecialValueFor("storm_radius", ability_level)
	local storm_duration	= ability:GetLevelSpecialValueFor("duration", ability_level)
	local vision_radius		= ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local linger_duration	= ability:GetLevelSpecialValueFor("linger_duration", ability_level)

	local target_point 		= keys.target_points[1]

	local dummy_storm		= CreateUnitByName("npc_dota_custom_dummy_unit", target_point, true, caster, caster, caster:GetTeamNumber())
	dummy_storm:AddNewModifier(dummy_storm, nil, "modifier_no_healthbar", {duration = -1})

	local storm_fx			= ParticleManager:CreateParticle(particle_storm, PATTACH_ABSORIGIN, dummy_storm)

	caster:EmitSound(sound_cast)

	ParticleManager:SetParticleControl(storm_fx, 0, dummy_storm:GetAbsOrigin())
	ParticleManager:SetParticleControl(storm_fx, 2, Vector(storm_duration, 0, 0))

	if dummy_storm ~= nil then
		Timers:CreateTimer(
			function()
				local units = FindUnitsInRadius(
					caster:GetTeam(),
					dummy_storm:GetAbsOrigin(),
					nil,
					vision_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO, 
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					true)

				for _, unit in ipairs(units) do
					if (unit:GetAbsOrigin() - dummy_storm:GetAbsOrigin()):Length2D() < storm_radius then
						unit:AddNewModifier(caster, ability, "modifier_storm_silence", {duration = linger_duration})
					end
				end

				return linger_duration
			end
		)
	end

	Timers:CreateTimer(storm_duration,
		function()
			dummy_storm:RemoveSelf()
		end
	)
end

modifier_storm_silence = class({})

function modifier_storm_silence:IsHidden()
	return false
end

function modifier_storm_silence:IsDebuff()
	return true
end

function modifier_storm_silence:IsPurgable()
	return false
end

function modifier_storm_silence:GetTexture()
	return "disruptor_static_storm"
end

function modifier_storm_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}

	return state
end