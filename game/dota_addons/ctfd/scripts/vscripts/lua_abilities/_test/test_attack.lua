test_lua = class({})
LinkLuaModifier( "modifier_test", "lua_abilities/test/modifier_test", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function test_lua:GetIntrinsicModifierName()
	return "modifier_test"
end

--[[
Invoking results:
[none]
	MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK
	MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_PROC
	MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE

[loop]
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS

[normal attack]
	[animation started] ---------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_START
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	MODIFIER_PROPERTY_PRE_ATTACK
	
	[projectile launched] -------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK
	
	[animation finished] --------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_FINISHED
	
	[projectile arrived] --------------------------------------------------------------------
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	MODIFIER_EVENT_ON_ATTACK_LANDED
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	MODIFIER_EVENT_ON_ATTACKED
	MODIFIER_EVENT_ON_TAKEDAMAGE

[cancelled attack]
	[animation started] ---------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_START
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	MODIFIER_PROPERTY_PRE_ATTACK

	[animation finished] --------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_FINISHED

[missed attack]
	[animation started] ---------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_START
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	MODIFIER_PROPERTY_PRE_ATTACK

	[projectile launched] -------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK

	[animation finished] --------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_FINISHED

	[projectile arrived] --------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_FAIL

[being attacked]
	[projectile arrived] --------------------------------------------------------------------
	MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT
	MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	MODIFIER_PROPERTY_AVOID_DAMAGE
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	MODIFIER_PROPERTY_MIN_HEALTH

[two-script attack]
	[animation started] ---------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_START
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	MODIFIER_PROPERTY_PRE_ATTACK

	[projectile launched] -------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK

	[animation finished] --------------------------------------------------------------------
	MODIFIER_EVENT_ON_ATTACK_FINISHED

	[projectile arrived] --------------------------------------------------------------------
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	MODIFIER_EVENT_ON_ATTACK_LANDED

		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
		MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
		MODIFIER_PROPERTY_AVOID_DAMAGE
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	MODIFIER_EVENT_ON_ATTACKED
		MODIFIER_PROPERTY_MIN_HEALTH
	MODIFIER_EVENT_ON_TAKEDAMAGE

		?? (before min-health) MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK

[dealing ability]
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	MODIFIER_EVENT_ON_TAKEDAMAGE

[struck ability]
	MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	MODIFIER_PROPERTY_AVOID_DAMAGE
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	MODIFIER_PROPERTY_MIN_HEALTH

[two-script ability]
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
		MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
		MODIFIER_PROPERTY_AVOID_DAMAGE
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
		MODIFIER_PROPERTY_MIN_HEALTH
	MODIFIER_EVENT_ON_TAKEDAMAGE

[Damaging calculations]
B00: Base damage
BBD: Base bonus damage
TBD: Total base damage
BML: Base multiplier
FBD: Flat bonus damage
TFB: Total flat bonus damage
TML: Total multiplier
DPC: Total Damage pre-crit
CRM: Critical multiplier
BPC: Bonus damage post-crit
FDD: Final damage delivered
BDP: Bonus Damage Physical
BDM: Bonus Damage Magical
BDR: Bonus Damage Pure

base damage		bonus damage
-- base hero damage
B00

-- base bonus damage
+BBD
B00+BBD=TBD

-- base multiplier
+0			+(TBD)*BML
TBD			TBD*BML

-- flat bonus damage
+0			+FBD
TBD			TBD*BML + FBD = TFB

-- total multiplier
+0			+(TBD + TFB)*TML
TBD			TFB + (TBD+TFB)*TML

-- damage pre-crit
DPC

-- critical multiplier
+DPC*(1-CRM)
DPC*CRM

-- bonus damage post-crit
+BPC
DPC*CRM + BPC

-- Final attack damage before delivered
FDD

-- Add bonus damage: physical, magical, pure
+BDP		+BDM		+BDR
FDD+BDP		BDM			BDR
ADP			ADM			ADP

-- constant physical block
-CPB		0			0

-- armor reduction
-ARP		0			0

-- physical bonus percentage
+PBP 		0			0

-- spell damage constant
0			+SDC 		0

-- magic resistance
0			-MRP 		0

-- total damage before special manipulation
TAD

-- incoming damage percentage
TAD*IDP

-- outgoing damage percentage
TAD*IDP*ODP

-- final constant block
TAD*IDP*ODP - FCB
FINAL


[Lifesteal effects]
All bonus attack source can get lifesteal
lifesteal depends on the damage taken.
If the attack does not give damage, no lifesteal taken.

none can get spell lifesteal

[Blademail effects]
Only up to bonus-damages will be reflected.
]]