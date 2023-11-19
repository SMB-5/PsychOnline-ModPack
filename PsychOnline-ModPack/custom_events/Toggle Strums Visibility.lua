
function onEvent(eventName, value1, value2)
	if eventName == 'Toggle Strums Visibility' then
		strum = tonumber(value1)
		strumset = 'opponentStrums'

		if strum > 3 then
			strumset = 'playerStrums'
		end
		
		strum = tonumber(value1) % 4
		setPropertyFromGroup(strumset, strum, 'visible', value2 == '1')
	end
end


function split (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end
