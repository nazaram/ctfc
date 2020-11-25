LinkLuaModifier("modifier_stasis_root", "heroes/hero_techies/ctf_techies_stasis_wire.lua", LUA_MODIFIER_MOTION_NONE)

ctf_techies_stasis_wire = class ({})

function OnSpellStart( keys )
	local particle_plant		= "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf"
	local particle_apear		= "particles/units/heroes/hero_techies/techies_stasis_trap_apear.vpcf"
	local particle_ring			= "particles/units/heroes/hero_techies/techies_stasis_plant_elec_rad.vpcf"
	local particle_beam			= "particles/units/heroes/hero_techies/techies_stasis_trap_beams.vpcf"

	local sound_plant			= "Hero_Techies.StasisTrap.Plant"
	local sound_detonate		= "Hero_Techies.StasisTrap.Stun"

	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()

	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local placement_distance	= ability:GetLevelSpecialValueFor("placement_distance", ability_level)
	local root_duration			= ability:GetLevelSpecialValueFor("root_duration", ability_level)
	local root_radius			= ability:GetLevelSpecialValueFor("root_radius", ability_level)
	local num_traps				= ability:GetLevelSpecialValueFor("num_traps", ability_level)
	local trap_duration			= ability:GetLevelSpecialValueFor("trap_duration", ability_level)

	local placement_angle		= 360 / num_traps
	local placement_pos 		= {}
	local dummies 				= {}

	caster:EmitSound(sound_plant)

	for i = 1, num_traps do 

		placement_pos[i]		= RotatePosition(Vector(0,0,0), QAngle(0, placement_angle * i, 0), caster:GetForwardVector()) * placement_distance + caster_location
		
		dummies[i] 				= CreateUnitByName("npc_dota_custom_dummy_unit", placement_pos[i], true, caster, caster, caster:GetTeamNumber())
		dummies[i]:AddNewModifier(dummies[i], nil, "modifier_no_healthbar", {duration = -1})

		Physics:Unit(dummies[i])

		dummies[i]:SetAutoUnstuck(true)
		dummies[i]:Hibernate(false)
		dummies[i]:SetGroundBehavior(PHYSICS_GROUND_LOCK)

		local plant_fx			= ParticleManager:CreateParticle(particle_plant, PATTACH_ABSORIGIN, dummies[i])
		local apear_fx			= ParticleManager:CreateParticle(particle_apear, PATTACH_ABSORIGIN, dummies[i])
		local ring_fx			= ParticleManager:CreateParticle(particle_ring, PATTACH_ABSORIGIN, dummies[i])

		ParticleManager:SetParticleControl(plant_fx, 1, placement_pos[i])
		ParticleManager:SetParticleControl(apear_fx, 3, placement_pos[i])
		ParticleManager:SetParticleControl(ring_fx, 1, placement_pos[i])

		if dummies[i] ~= nil then

			local units = FindUnitsInRadius(
				caster:GetTeam(),
				dummies[i]:GetAbsOrigin(),
				nil,
				root_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				true)

			for _, unit in ipairs(units) do
				if (unit:GetAbsOrigin() - dummies[i]:GetAbsOrigin()):Length2D() < root_radius then
					unit:AddNewModifier(caster, ability, "modifier_stasis_root", {duration = root_duration})

					local beam_fx = ParticleManager:CreateParticle(particle_beam, PATTACH_ABSORIGIN, caster)

					ParticleManager:SetParticleControl(beam_fx, 0, unit:GetAbsOrigin())
					ParticleManager:SetParticleControl(beam_fx, 1, dummies[i]:GetAbsOrigin())

					unit:EmitSound(sound_detonate)

					Timers:CreateTimer(root_duration,
						function()
							ParticleManager:ReleaseParticleIndex(beam_fx)
						end
					)
				end
			end
		end
	end

	Timers:CreateTimer(trap_duration, 
		function()
			for i = 1, num_traps do 
				dummies[i]:RemoveSelf()
			end
		end
	)	
end

-- =====================================================================================================================
-- Enemy Effect Modifier: Root and FOW vision
-- =====================================================================================================================

modifier_stasis_root = class({})

function modifier_stasis_root:IsHidden()
	return false
end

function modifier_stasis_root:IsDebuff()
	return true
end

function modifier_stasis_root:IsPurgable()
	return true
end

function modifier_stasis_root:GetEffectName()
	return "particles/units/heroes/hero_techies/techies_stasis_trap_beams_flash.vpcf"
end

function modifier_stasis_root:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_stasis_root:GetTexture()
	return "techies_stasis_trap"
end

function modifier_stasis_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

