LinkLuaModifier("modifier_stifle", "heroes/hero_phantom_assassin/ctf_dagger.lua", LUA_MODIFIER_MOTION_NONE)

ctf_dagger = class({})

function OnSpellStart( keys )
	local model_dagger			= "models/particle/phantom_assassin_dagger_model.vmdl"

	local particle_launch 		= "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_launch.vpcf"
	local particle_trail		= "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_trail.vpcf"
	local particle_trail_c		= "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_trail_c.vpcf"
	local particle_explosion 	= "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_explosion.vpcf"

	local sound_launch			= "Hero_PhantomAssassin.Dagger.Cast"
	local sound_hit				= "Hero_PhantomAssassin.Dagger.Target"

	local caster 				= keys.caster
	local caster_location 		= caster:GetAbsOrigin()

	local ability 				= keys.ability
	local ability_level 		= ability:GetLevel() - 1

	local dagger_speed 			= ability:GetLevelSpecialValueFor("dagger_speed", ability_level)
	local dagger_range 			= ability:GetLevelSpecialValueFor("dagger_range", ability_level)
	local slow_duration 		= ability:GetLevelSpecialValueFor("slow_duration", ability_level)
	local search_radius			= ability:GetLevelSpecialValueFor("search_radius", ability_level)
	local new_vision_range		= ability:GetLevelSpecialValueFor("vision_range", ability_level)

	local target_point 			= keys.target_points[1]

	local direction 			= (target_point - caster_location):Normalized()

	local dummy_dagger 			= CreateUnitByName("npc_dota_custom_dummy_unit", caster_location, true, caster, caster, caster:GetTeamNumber())
	local launch_fx				= ParticleManager:CreateParticle(particle_launch, PATTACH_ABSORIGIN, dummy_dagger)
	local trail_fx				= ParticleManager:CreateParticle(particle_trail, PATTACH_ABSORIGIN, dummy_dagger)
	local trail_c_fx			= ParticleManager:CreateParticle(particle_trail_c, PATTACH_ABSORIGIN, dummy_dagger)
	local explosion_fx 			= ParticleManager:CreateParticle(particle_explosion, PATTACH_ABSORIGIN, caster)

	caster:EmitSound(sound_launch)

	ParticleManager:SetParticleControl(launch_fx, 3, dummy_dagger:GetAbsOrigin())

	dummy_dagger:AddNewModifier(dummy_dagger, nil, "modifier_no_healthbar", {duration = -1})

	dummy_dagger:SetOriginalModel(model_dagger)
	dummy_dagger:SetModel(model_dagger)
	dummy_dagger:SetModelScale(3)

	Physics:Unit(dummy_dagger)

	dummy_dagger:PreventDI(true)
	dummy_dagger:SetAutoUnstuck(true)
	dummy_dagger:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	dummy_dagger:FollowNavMesh(false)
	dummy_dagger:SetPhysicsVelocityMax(dagger_speed)
	dummy_dagger:SetPhysicsVelocity(dagger_speed * direction)
	dummy_dagger:SetPhysicsFriction(0)
	dummy_dagger:Hibernate(false)
	dummy_dagger:SetGroundBehavior(PHYSICS_GROUND_ABOVE)

	dummy_dagger:OnPhysicsFrame(
		function()
			local progress = (dummy_dagger:GetAbsOrigin() - caster_location):Length2D()

			dummy_dagger:SetForwardVector(dummy_dagger:GetPhysicsVelocity())

			ParticleManager:SetParticleControl(trail_fx, 3, dummy_dagger:GetAbsOrigin())
			ParticleManager:SetParticleControl(trail_c_fx, 3, dummy_dagger:GetAbsOrigin())

			if dummy_dagger ~= nil then
				local units = FindUnitsInRadius(
					caster:GetTeam(),
					dummy_dagger:GetAbsOrigin(),
					nil,
					search_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_CLOSEST,
					true)

				for _, unit in ipairs(units) do
					if (unit:GetAbsOrigin() - dummy_dagger:GetAbsOrigin()):Length2D() < search_radius then
						
						ParticleManager:SetParticleControl(explosion_fx, 3, unit:GetAbsOrigin())
						unit:AddNewModifier(caster, ability, "modifier_stifle", {duration = slow_duration})
						unit:EmitSound(sound_hit)
						caster:EmitSound(sound_hit)

						dummy_dagger:RemoveSelf()
					end
				end
			end

			if progress >= dagger_range then
				dummy_dagger:RemoveSelf()
			end
		end
	)
end

-- =====================================================================================================================
-- Enemy Effect Modifier: Slow and reduce vision radius
-- =====================================================================================================================

modifier_stifle = class({})

gslow = -50
gvis = -40

function modifier_stifle:IsHidden()
	return false
end

function modifier_stifle:IsDebuff()
	return true
end

function modifier_stifle:IsPurgable()
	return true
end

function modifier_stifle:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_launch.vpcf"
end

function modifier_stifle:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_stifle:GetTexture()
	return "phantom_assassin_stifling_dagger"
end

function modifier_stifle:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
	}

	return funcs
end

function modifier_stifle:GetModifierMoveSpeedBonus_Percentage()
	return gslow
end

function modifier_stifle:GetBonusVisionPercentage()
	return gvis
end
