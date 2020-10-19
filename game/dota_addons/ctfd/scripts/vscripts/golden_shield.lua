golden_shield_lua =class({})

LinkLuaModifier("modifier_golden_shield_lua", LUA_MODIFIER_MOTION_NONE)

function golden_shield_lua:OnSpellStart()
	print("Golden Shield Applied!");
	local target = self.GetTarget();
	target:AddNewModifier(target, self, "modifier_golden_shield_lua", {duration = 3});

end
