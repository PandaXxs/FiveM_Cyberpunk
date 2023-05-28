ESX.RegisterServerCallback("IfHasMoneyDistrib",function(source, cb, price, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price and xPlayer.canCarryItem(item, 1) then
        xPlayer.removeMoney(price)
        xPlayer.addInventoryItem(item, 1)
        xPlayer.showNotification('Vous avez ~b~effectué~s~ un ~b~paiement~s~ de ~b~'..price..'$~s~ pour 1 ~b~'..item..'')  	
        cb(true)
    else
        cb(false)
    end
end)