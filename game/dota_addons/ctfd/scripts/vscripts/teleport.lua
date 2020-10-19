function Teleport(trigger)
  if _G.Button == 1 then
	print("teleport good")
	local point1 = Entities:FindByName( nil, "point_teleport_good" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point1, false)
    trigger.activator:Stop()
    SendToConsole("dota_camera_center")
  end
 if _G.Button == 2 then
 	print("teleport bad")
	local point1 = Entities:FindByName( nil, "point_teleport_bad" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point1, false)
    trigger.activator:Stop()
    SendToConsole("dota_camera_center")
 end
end

function Teleport_Bad(trigger)
  if _G.Button == 2 then
	local point1 = Entities:FindByName( nil, "point_teleport_neutral" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point1, false)
    trigger.activator:Stop()
    SendToConsole("dota_camera_center")
  end
end

function Teleport_Good(trigger)
  if _G.Button == 1 then
	local point1 = Entities:FindByName( nil, "point_teleport_neutral" ):GetAbsOrigin()
    FindClearSpaceForUnit(trigger.activator, point1, false)
    trigger.activator:Stop()
    SendToConsole("dota_camera_center")
  end
end


 function ButtonPress(trigger)
  if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
   	print("button press good")
  	_G.Button = 2
  	arrow_neutral:SetEnabled(false) 
  	arrow_bad:SetEnabled(true) 
  	bad_button:SetEnabled(true)
  	arrow_good:SetEnabled(false) 
  	good_button:SetEnabled(false)
  end
  if trigger.activator and trigger.activator:GetTeamNumber() == DOTA_TEAM_BADGUYS then
  	print("button press bad")
  	_G.Button = 1
  	arrow_neutral:SetEnabled(false) 
  	arrow_bad:SetEnabled(false) 
  	bad_button:SetEnabled(false)
  	arrow_good:SetEnabled(true) 
  	good_button:SetEnabled(true)
  end
end
