function giveUnitDataDrivenModifier(source, target, modifier,dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_magic_resistance", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end