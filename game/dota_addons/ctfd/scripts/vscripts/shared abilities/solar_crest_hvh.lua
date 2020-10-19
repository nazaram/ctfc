-- modded by veggiesama
--[[ ============================================================================================================
	Author: Rook
	Date: February 4, 2015
	Called when Solar Crest is cast.  Applies an armor debuff to the caster.  If cast on an enemy, applies
	an armor debuff to them as well; if cast on an ally, applies an armor buff to them.
================================================================================================================= ]]
function item_solar_crest_hvh_on_spell_start(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if caster:GetTeam() == target:GetTeam() then  --If Solar Crest is cast on an ally.
		if caster ~= target then  --If Solar Crest wasn't self-casted.
			--ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_solar_crest_hvh_caster_debuff", nil)
			ability:ApplyDataDrivenModifier(caster, target, "modifier_item_solar_crest_hvh_buff", nil)
			
			caster:EmitSound("DOTA_Item.MedallionOfCourage.Activate") -- TODO: fix sound
			target:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
		else  --If Solar Crest was self-casted, which it's not supposed to be able to do.
			--ability:RefundManaCost()
			ability:EndCooldown()
			EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", caster:GetPlayerOwner())
			return UF_FAIL_CUSTOM
			--This makes use of the Custom Error Flash module by zedor. https://github.com/zedor/CustomError
			--FireGameEvent('custom_error_show', {player_ID = caster:GetPlayerID(), _error = "Ability Can't Target Self"})
		end
	else  --If Solar Crest is cast on an enemy.
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_solar_crest_hvh_caster_debuff", nil)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_item_solar_crest_hvh_debuff", nil)
		
		caster:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
		target:EmitSound("DOTA_Item.MedallionOfCourage.Activate")
	end
end
