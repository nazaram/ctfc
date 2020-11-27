LinkLuaModifier("modifier_glimpse_backtrack", "heroes/hero_disruptor/ctf_glimpse.lua", LUA_MODIFIER_MOTION_NONE)

ctf_glimpse = class({})

function OnSpellStart( keys )
	local particle_strike		= "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
	local particle_glimpse_end 	= "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf"

	local sound_cast			= "Hero_Disruptor.ThunderStrike.Cast"

	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()
	local ability 				= keys.ability
	local ability_level			= ability:GetLevel() - 1

	local num_strikes			= ability:GetLevelSpecialValueFor("num_strikes", ability_level)
	local strike_radius			= ability:GetLevelSpecialValueFor("strike_radius", ability_level)
	local travel_time			= ability:GetLevelSpecialValueFor("travel_time", ability_level)
	local backtrack_time		= ability:GetLevelSpecialValueFor("backtrack_time", ability_level)

	local max_range				= ability:GetCastRange()

	local target_point			= keys.target_points[1]
	local direction 			= (target_point - caster_location):Normalized()

	local strike_pos			= {}
	local dummy_strikes			= {}

	for i = 1, num_strikes do
		strike_pos[i] = caster_location + i * direction * max_range / num_strikes
	end

	local strike_count = 1

	Timers:CreateTimer(
		function()
			dummy_strikes[strike_count] = CreateUnitByName("npc_dota_custom_dummy_unit", strike_pos[strike_count], true, caster, caster, caster:GetTeamNumber())

			dummy_strikes[strike_count]:AddNewModifier(dummy_strikes[strike_count], nil, "modifier_no_healthbar", {duration = -1})

			local strike_fx = ParticleManager:CreateParticle(particle_strike, PATTACH_ABSORIGIN, dummy_strikes[strike_count])
			dummy_strikes[strike_count]:EmitSound(sound_cast)

			if strike_count == 1 then
				ParticleManager:SetParticleControl(strike_fx, 1, caster_location)
			else	
				ParticleManager:SetParticleControl(strike_fx, 1, dummy_strikes[strike_count - 1]:GetAbsOrigin())
			end

			ParticleManager:SetParticleControl(strike_fx, 0, dummy_strikes[strike_count]:GetAbsOrigin())
			ParticleManager:SetParticleControl(strike_fx, 2, dummy_strikes[strike_count]:GetAbsOrigin())

			if dummy_strikes ~= nil then

				local units = FindUnitsInRadius(
					caster:GetTeamNumber(),
					dummy_strikes[strike_count]:GetAbsOrigin(),
					nil,
					strike_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_CLOSEST,
					true)

				for _, unit in ipairs(units) do
					if (unit:GetAbsOrigin() - dummy_strikes[strike_count]:GetAbsOrigin()):Length2D() < strike_radius then
						unit:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.01})
						unit:AddNewModifier(caster, nil, "modifier_glimpse_backtrack", {duration = backtrack_time})

						local glimpse_end_fx = ParticleManager:CreateParticle(particle_glimpse_end, PATTACH_ABSORIGIN, dummy_strikes[strike_count])
						local temp_count = strike_count

						ParticleManager:SetParticleControl(glimpse_end_fx, 1, strike_pos[temp_count])
						ParticleManager:SetParticleControl(glimpse_end_fx, 2, Vector(backtrack_time, 0, 0))
						
						-- Timers:CreateTimer(backtrack_time - backtrack_time * 0.25,
						-- 	function()

						-- 	end
						-- )
						Timers:CreateTimer(backtrack_time,
							function()
								FindClearSpaceForUnit(unit, strike_pos[temp_count], true)
							end
						)
					end
				end
			end

			strike_count = strike_count + 1

			if strike_count <= num_strikes then	
				return travel_time / num_strikes
			end
		end
	)
end

-- =====================================================================================================================
-- Enemy Effect Modifier: Timer to show when they will be glimpsed
-- =====================================================================================================================

modifier_glimpse_backtrack = class({})

function modifier_glimpse_backtrack:IsHidden()
	return false
end

function modifier_glimpse_backtrack:IsDebuff()
	return true
end

function modifier_glimpse_backtrack:IsPurgable()
	return false
end
function modifier_glimpse_backtrack:GetTexture()
	return "disruptor_glimpse"
end

function modifier_glimpse_backtrack:GetEffectName()
	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
end

function modifier_glimpse_backtrack:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end