LinkLuaModifier( "modifier_lil_stinky_slow", "heroes/hero_pudge/ctf_pudge_lil_stinky.lua", LUA_MODIFIER_MOTION_NONE )



ctf_pudge_lil_stinky = class({})

function OnSpellStart ( keys )
	local caster 				= keys.caster
	local caster_location		= caster:GetAbsOrigin()
	local ability 				= keys.ability

	ability.level 				= ability:GetLevel()
	-- gslow 						= - ability:GetLevelSpecialValueFor("movespeed_slow", ability.level - 1)

	local radius 				= ability:GetLevelSpecialValueFor("radius", ability.level - 1)
	local plant_range			= ability:GetLevelSpecialValueFor("plant_range", ability.level - 1)
	local duration 				= ability:GetLevelSpecialValueFor("duration", ability.level - 1)
	local linger_duration		= ability:GetLevelSpecialValueFor("linger_duration", ability.level - 1)
	local particle_name1 		= "particles/units/heroes/hero_pudge/pudge_rot.vpcf"
	
	local target 				= - plant_range * caster:GetForwardVector()
	local target_location		= caster_location + target
	
	local dummy = CreateUnitByName("npc_dota_custom_dummy_unit", target_location, false, caster, caster, caster:GetTeamNumber())
	dummy:AddNewModifier(dummy, nil, "modifier_no_healthbar", {duration = -1})

	local particle1 = ParticleManager:CreateParticle(particle_name1, PATTACH_ABSORIGIN, dummy)

	ParticleManager:SetParticleControl(particle1, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle1, 1, Vector(radius, 0, 0))


	if dummy ~= nil then

		Timers:CreateTimer(
			function()
				local units = FindUnitsInRadius(
				caster:GetTeam(), 
				caster_location, 
				nil,
				radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				true)

				for _, unit in ipairs(units) do
					if ((unit:GetAbsOrigin() - dummy:GetAbsOrigin()):Length2D()) < radius then
						unit:AddNewModifier(caster, ability, "modifier_lil_stinky_slow", {duration = linger_duration})					
					end
				end

				return 0.25
			end
		)
		-- After duration seconds destory dummy rot unit
		Timers:CreateTimer(duration,
			function()
				dummy:RemoveSelf()

				ParticleManager:ReleaseParticleIndex(particle1)
			end
		)
	end
end

modifier_lil_stinky_slow = class({})

--can't figure out how retrieve and refernce the move slow value so it just has to be a global variable here
gslow = -40

function modifier_lil_stinky_slow:IsHidden()
	return false
end

function modifier_lil_stinky_slow:IsDebuff()
	return true
end

function modifier_lil_stinky_slow:IsPurgable()
	return false
end

function modifier_lil_stinky_slow:GetEffectName()
	return "particles/econ/items/pudge/pudge_tassles_of_black_death/pudge_rot_recipient_d_dc.vpcf"
end

function modifier_lil_stinky_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
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
	return gslow
end