-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

--Customize notifications
RegisterNetEvent('wasabi_carlock:notify', function(title, desc, style, icon)
    lib.notify({
        title = title,
        description = desc or '',
        duration = 3500,
        type = style,
        icon = icon or false
    })
end)
