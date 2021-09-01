RegisterServerEvent('dans_fines:server:fine')
AddEventHandler('dans_fines:server:fine', function(source, rPlayer, fineName, fineCost)
    local _source = source
    local _rPlayer = rPlayer

    -- Fine Details
    local _fineName = fineName
    local _fineCost = fineCost

    -- Fine Receiver
    local owner = ""
    local ownerCharId = 1
    local ownerName = ""

    -- Fine Giver
    local giver = ""
    local giverCharId = 1
    local giverName = ""
    


    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        giver = user.getIdentifier()
        giverCharId = user.getSessionVar("charid")
        giverName = user.getFirstname() .." ".. user.getLastname()
    end)

    TriggerEvent('redemrp:getPlayerFromId', _rPlayer, function(user)
        owner = user.getIdentifier()
        ownerCharId = user.getSessionVar("charid")
        ownerName = user.getFirstname() .." ".. user.getLastname()
    end)

    print(giverName)
    print(giver)
    print(giverCharId)

    MySQL.Async.execute('INSERT INTO user_fines (owner, ownerCharId, ownerName, price, fine, giver, giverCharId, giverName) VALUES (@owner, @ownerCharId, @ownerName, @price, @fine, @giver, @giverCharId, @giverName)',
    { ['owner'] = owner, ['ownerCharId'] = ownerCharId, ['ownerName'] = ownerName, ['price'] = _fineCost, ['fine'] = _fineName, ['giver'] = giver, ['giverCharId'] = giverCharId, ['giverName'] = giverName})
end)

RegisterServerEvent('dans_fines:server:getFines')
AddEventHandler('dans_fines:server:getFines', function(source)
    local Fines = {}
    local _source = source
    local owner = ""
    local ownerCharId = 1

    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        owner = user.getIdentifier()
        ownerCharId = user.getSessionVar("charid")
    end)

    MySQL.Async.fetchAll('SELECT * FROM user_fines WHERE owner = @owner AND ownerCharId = @ownerCharId', { ['@owner'] = owner, ['@ownerCharId'] = ownerCharId }, function(result)

        Config.PlayerFines = {}

        for i=1, #result, 1 do
            table.insert(Config.PlayerFines, {
                id = result[i].id,
                fine = result[i].fine,
                price = result[i].price,
            })
        end
        --print(json.encode(Config.PlayerFines))
        TriggerClientEvent('dans_fines:client:getFines', _source, Config.PlayerFines)
    end)   
end)

RegisterServerEvent('dans_fines:server:payFine')
AddEventHandler('dans_fines:server:payFine', function(fineID, fineCost)
    local _source = source
    local _fineID = fineID
    local _fineCost = fineCost

    print(_source)
    print(_fineID)
    print(_fineCost)

    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        if user.getMoney() >= _fineCost then
            user.removeMoney(_fineCost)
            MySQL.Async.execute('DELETE FROM user_fines WHERE id = @id', { ['@id'] = _fineID }, function(rowsChanged)
            end)
        end
    end)
end)