LinkLuaModifier( "modifier_jugg_spin", "heroes/hero_juggernaut/jugg_bladefury.lua", LUA_MODIFIER_MOTION_NONE )


juggernaut_blade_fury_lua = class({})

--------------------------------------------------------------------------------
-- Ability Start
function jugg_bladefury( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()

	local ability 				= keys.ability
	ability.level 				= ability:GetLevel()

	local radius 				= ability:GetLevelSpecialValueFor("radius", ability.level - 1)	
	local duration 				= ability:GetLevelSpecialValueFor("duration", ability.level - 1)

	local particle_name = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal.vpcf"

	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]

	ParticleManager:SetParticleControl(particle, 0, caster_location) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	
	-- After duration end particles
	Timers:CreateTimer(duration, 
		function()
			ParticleManager:DestroyParticle(particle, false)
		end
	)
end

modifier_jugg_spin = class({})