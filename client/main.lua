MenuData = {}
TriggerEvent("redemrp_menu_base:getData",function(call)
    MenuData = call
end)

-- Test Function | Uses Left Arrow for Fining, Right Arrow for viewing fines
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         if IsControlJustPressed(0, 0xA65EBAB4) then
--             giveFineMenu()
--         elseif IsControlJustPressed(0, 0xDEB34313) then
--             viewFineMenu()
--         end
--     end
-- end)

function giveFineMenu()
    MenuData.CloseAll()
    local elements = {}

    local elements = {
        {label = "Minor Fines", value = 'minor', desc = "Minor Fine List"},
        {label = "Medium Fines", value = 'medium', desc = "Medium Fine List"},
        {label = "Harsh Fines", value = 'harsh', desc = "Harsh Fine List"},
    }

    MenuData.Open('default', GetCurrentResourceName(), 'giveFine_menu', {
        title = "Fines Menu",
        subtext = "Fine Nearby Players",
        align = 'top-left',
        elements = elements,
    },
    function(data, menu)
        local elements2 = {}
        local OpenSub = false
        local title2 = ""
        local subtext2 = ""
        local vl = data.current.value
        if(vl == 'minor') then
            title2 = "Minor Fines"
            subtext2 = "Minor Fine List"
            elements2 = {}
            for k,minorFines in ipairs(Config.Fines.SoftFines) do
                table.insert(elements2, {label = minorFines.Name .." - $".. minorFines.Price, value = minorFines.FineID, price = minorFines.Price})
            end
            OpenSub = true
        elseif(vl == 'medium') then
            title2 = "Medium Fines"
            subtext2 = "Medium Fine List"
            elements2 = {}
            for k,mediumFines in ipairs(Config.Fines.MediumFines) do
                table.insert(elements2, {label = mediumFines.Name .." - $".. mediumFines.Price, value = mediumFines.FineID, price = mediumFines.Price})
            end
            OpenSub = true
        elseif(vl == 'harsh') then
            title2 = "Harsh Fines"
            subtext2 = "Harsh Fine List"
            elements2 = {}
            for k,harshFines in ipairs(Config.Fines.HarshFines) do
                table.insert(elements2, {label = harshFines.Name .." - $".. harshFines.Price, value = harshFines.FineID, price = harshFines.Price})
            end
            OpenSub = true
        end

        if OpenSub == true then
            OpenSub = false
            MenuData.Open('default', GetCurrentResourceName(), 'giveFine_'..vl, {
                title = title2,
                subtext = subtext2,
                align = 'top-left',
                elements = elements2,
            },
            function(data2, menu2)
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('dans_fines:server:fine', GetPlayerServerId(), GetPlayerServerId(closestPlayer), data2.current.label, data2.current.price)
                else
                    --print("No one nearby!")
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

function viewFineMenu()
    MenuData.CloseAll()
    local elements = {}
    TriggerServerEvent('dans_fines:server:getFines', GetPlayerServerId()) 
    Citizen.Wait(500)

    for k,fines in ipairs(Config.PlayerFines) do
        table.insert(elements, {label = fines.fine, price = fines.price, id = fines.id})
    end

    MenuData.Open('default', GetCurrentResourceName(), 'viewFine_menu', {
        title = "Fines",
        subtext = "View Fines",
        align = 'top-left',
        elements = elements,
    },
    function(data, menu)
        local elements2 = {}
        local OpenSub = false
        local title2 = ""
        local subtext2 = ""
        local id = data.current.id 

        title2 = "Pay Fines"
        subtext2 = "Pay Fine Amount"
        elements2 = {
            {label = "Yes - $"..data.current.price, value = 'yes'},
            {label = "No", value = 'no'},
        }
        OpenSub = true

        if OpenSub == true then
            OpenSub = false
            MenuData.Open('default', GetCurrentResourceName(), 'fines_'..id, {
                title = title2,
                subtext = subtext2,
                align = 'top-left',
                elements = elements2,
            },
            function(data2, menu2)
                if data2.current.value == "yes" then
                    local price = data.current.price
                    local id = data.current.id
                    print("paid $".. price)
                    print("Fine ID: ".. id)
                    TriggerServerEvent('dans_fines:server:payFine', id, price)
                    menu2.close()
                    menu.close()
                elseif data2.current.value == "no" then
                    print("didnt")
                    menu2.close()
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)
        end
    end,

    function(data, menu)
        menu.close()
    end)
end

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
	local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
    end
    
	for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end

RegisterNetEvent('dans_fines:client:getFines')
AddEventHandler('dans_fines:client:getFines', function(Fines)
    Config.PlayerFines = Fines
end)
