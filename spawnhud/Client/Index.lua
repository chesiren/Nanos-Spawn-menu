-- Spawns a WebUI with the HTML file you just created
SpawnHUD = WebUI("Spawn HUD", "file:///UI/index.html", true)
SpawnHUD:SetVisible(false)
Client:SetCrosshairEnabled(true)

local hold = false
Client:on("KeyDown", function(KeyName)
    if (KeyName == "I") then
		if hold == false then
			hold = true
			
			SpawnHUD:SetVisible(true)
			Client:SetMouseEnabled(true)
		end
    end
end)

Client:on("KeyUp", function(KeyName)
    if (KeyName == "I") then
		if hold then
			hold = false
			
			SpawnHUD:SetVisible(false)
			Client:SetMouseEnabled(false)
		end
    end
end)

SpawnHUD:on("Spawn", function(input)
	if input == nil then Package:Log("[Event received from WebUI] input is nil") end
	
	local viewPortX = Render:GetViewportSize().X / 2
    local viewPortY = Render:GetViewportSize().Y / 2
    local newViewPort = Vector2D(viewPortX, viewPortY)
    
    local viewport = Render:Deproject(newViewPort)

    local trace_result = Client:Trace(viewport.Position, viewport.Position + viewport.Direction * 500, false) -- change to true for debug
    
    if (trace_result.Success) then
        --Client:DrawDebugPoint(trace_result.Location, Color(1, 0, 0), 1, 1)
		Package:Log(trace_result.Actor)
    end
	
	Package:Log("[Event received from WebUI] input: " .. input)
	Events:CallRemote("SpawnObject", {input, trace_result.Actor})
end)

SpawnHUD:on("Cleanup", function(input)
	if input == nil then Package:Log("[Event received from WebUI] input is nil") end
	
	Package:Log("[Event received from WebUI] input: " .. input)
	Events:CallRemote("Cleanup", {input})
end)

-- register for a server Event (remote = server)
Events:on("Notification", function(my_text)
    Package:Log("Event received from server! " .. my_text)
    -- outputs "Event received from server! hello nanos world!"
end)

Package:on("Unload", function()
	SpawnHUD:Destroy()
end)