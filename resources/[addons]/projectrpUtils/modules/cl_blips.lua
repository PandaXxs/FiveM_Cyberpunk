CreateThread(function() 
    for k, v in pairs(Config.Locations) do
        for j, l in pairs(v.Blips) do
            CreateBlip(l.pos, l.sprite, l.color, tostring(l.label), l.scale)
        end
    end
end)