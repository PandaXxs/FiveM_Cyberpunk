lib.callback.register('wasabi_carlock:getIdentifier', function(source, target)
    return GetIdentifier(target)
end)

Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end