--[[
	Author: kritth
	Date: 9.1.2015.
	Bubbles seen only to ally as pre-effect
]]
function torrent_bubble_allies( keys )
	local caster = keys.caster
	
	local allHeroes = HeroList:GetAllHeroes()
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf"
	local target = keys.target_points[1]
	
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			local fxIndex = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, v, PlayerResource:GetPlayer( v:GetPlayerID() ) )
			ParticleManager:SetParticleControl( fxIndex, 0, target )
			
			EmitSoundOnClient( "Ability.pre.Torrent", PlayerResource:GetPlayer( v:GetPlayerID() ) )
			
			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
					ParticleManager:DestroyParticle( fxIndex, false )
					return nil
				end
			)
		end
	end
end

--[[
	Author: kritth
	Date: 9.1.2015.
	Emit sound at location
]]
function torrent_emit_sound( keys )
	local ability = keys.ability
	local dummy = CreateUnitByName( "npc_dota_custom_dummy_unit", keys.target_points[1], false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	EmitSoundOn( "Ability.Torrent", dummy )
	dummy:ForceKill( true )
	local particle_torrent2 = "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf"
	local fx = ParticleManager:CreateParticle(particle_torrent2, PATTACH_ABSORIGIN, target)
	local duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1)

	Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle(fx, false)
			return nil
		end
		)
end

--[[
	Author: kritth, Pizzalol
	Date: February 24, 2016
	Provides obstructed vision of the area
]]
function torrent_vision( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	
	AddFOWViewer(caster:GetTeamNumber(),target,radius,duration,true)
end

function torrent_teleport (keys)
	local caster = keys.caster
	local ability = keys.ability

	if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
  		FindClearSpaceForUnit(caster, Vector(2819.38, 4127.27, 236.401), false)
  		caster:Stop()
  	end
	if caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
  		FindClearSpaceForUnit(caster, Vector(-2173.28, 4147.1, 146.139), false)
  		caster:Stop()
  	end

end