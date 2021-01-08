Package:RequirePackage("NanosWorldWeapons")
--[[
mt = {}          -- create the matrix
for i=1,N do
	mt[i] = {}     -- create a new row
	for j=1,M do
		mt[i][j] = 0
	end
end--]]
local list = {}

Player:on("Spawn", function(player)
	list[player] = {}
end)

Player:on("Destroy", function(player)

end)

Events:on("Cleanup", function(player, input)
	local tbl = list[player]
	for k,v in pairs(tbl) do
		v:Destroy()
		list[player][k] = nil
	end
end)

Events:on("SpawnObject", function(player, input, actor)
	if input == nil then Package:Log("[Event received from Client "..player:GetName().."] input is nil") end
	
	local type = string.sub(input, 1, 1)
	local sk_type = tonumber(string.sub(input, 2, 2))
	local sk_gender = tonumber(string.sub(input, 3, 3))
	local model = "NanosWorld::"..string.sub(input, 4)
	
    Package:Log("[Event received from Client "..player:GetName().."]  input: " .. input..", "..type.." "..sk_type.." "..sk_gender.." "..model)
	
	local character = player:GetControlledCharacter()
	local rotation = character:GetControlRotation()
    local forward_vector = rotation:GetForwardVector()
    local position = character:GetLocation() + Vector(0, 0, 50) + forward_vector * Vector(200)
	
	local sk_id = {"shirt", "pants", "shoes", "chest", "full", "beard", "hair", "weapon"}
	
	-- create object
	if type == "1" then -- prop
		local obj = Prop(position, rotation, model)
	elseif type == "2" then -- bot
		Character(position, Rotator(), model)
	elseif type == "3" then -- botcloth
		if (actor) then
			actor:RemoveStaticMeshAttached(sk_id[sk_type])
			actor:RemoveSkeletalMeshAttached(sk_id[sk_type])
			if (string.sub(input, 4, 5) == "SM") then
				actor:AddStaticMeshAttached(sk_id[sk_type], model)
			else
				actor:AddSkeletalMeshAttached(sk_id[sk_type], model)
			end
		end
	elseif type == "4" then -- botweapon
		if (actor) then
			actor:RemoveSkeletalMeshAttached(sk_id[sk_type])
			actor:AddSkeletalMeshAttached(sk_id[sk_type], model)
		end
	elseif type == "5" then -- item
		Item(position, rotation, model)
	elseif type == "6" then --vehicle
		Vehicle(position + Vector(0, 0, 50), rotation + Rotator(0, 90, 0), model)
	elseif type == "7" then -- weapon
		NanosWorldWeapons[string.sub(input, 4)](position, rotation)
	end
	
	
	list[player][lastnum] = obj
	--NanosWorldWeapons['SMG11'](Vector(), Rotator())
    -- sends an "answer" to the player which sent this event
    Events:CallRemote("Notification", player, {"hello nanos world! message only for you!"})
end)