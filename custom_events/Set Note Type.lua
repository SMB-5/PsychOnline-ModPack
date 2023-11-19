allNoteEvents = {};
function onCountdownStarted()
	luaDebugMode = true;
	for i = 0, getProperty('eventNotes.length') - 1 do
		local theEvent = getPropertyFromGroup('eventNotes', i, 'event')
		if preEvent[theEvent] then 
			local tableOfContents = {
				v1 = getPropertyFromGroup('eventNotes', i, 'value1'),
				v2 = getPropertyFromGroup('eventNotes', i, 'value2'),
				s = getPropertyFromGroup('eventNotes', i, 'strumTime')
			}
			preEvent[theEvent](tableOfContents); 
		end
	end
	
	table.sort(allNoteEvents, function(a, b) return a.s < b.s; end);
	
	for i = 1, #allNoteEvents do
		local curEvent = allNoteEvents[i];
		if curEvent.v1 ~= '' then
			local nextEvent = allNoteEvents[i + 1];
			
			for i = 0, getProperty('unspawnNotes.length') - 1 do
				local noteStr = getPropertyFromGroup('unspawnNotes', i, 'strumTime');
				if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') and getPropertyFromGroup('unspawnNotes', i, 'noteType') == '' and 
					noteStr >= curEvent.s and noteStr <= nextEvent.s then
					setPropertyFromGroup('unspawnNotes', i, 'noteType', curEvent.v1);
					setPropertyFromGroup('unspawnNotes', b, 'noAnimation', true);
				end
			end
		end
	end
end

preEvent = {
	['Set Note Type'] = function(t)
		table.insert(allNoteEvents, t);
	end
}
