-- -- make this true to make it run shit.
-- -- too many performance issues were caused by script so it had to be disabled by default
-- local doShit = false

-- function onCreatePost()
--     if not doShit then
--         close()
--     end
-- end

-- function onSongStart()
-- 	--Iterate over all notes
-- 	local notedData = false
-- 	for i = 0, getProperty('unspawnNotes.length')-1 do
-- 		if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
-- 			notedData = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
-- 			if notedData then
-- 				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
-- 				setPropertyFromGroup('unspawnNotes', i, 'blockHit', true);
-- 			elseif dadName == 'yellow' then
-- 				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
-- 			end
-- 		end
-- 	end
-- 	for i = 0, getProperty('notes.length')-1 do
-- 		if getPropertyFromGroup('notes', i, 'isSustainNote') then
-- 			notedData = getPropertyFromGroup('notes', i, 'mustPress')
-- 			if notedData then
-- 				setPropertyFromGroup('notes', i, 'ignoreNote', true); --Miss has no penalties
-- 				setPropertyFromGroup('notes', i, 'blockHit', true);
-- 			elseif dadName == 'yellow' then
-- 				setPropertyFromGroup('notes', i, 'noAnimation', true);
-- 			end
-- 		end
-- 	end
-- end

-- function goodNoteHit(id, noteData, noteType, isSustainNote)
-- 	-- if noteWasMiss[noteData+1] then
-- 	-- 	noteWasMiss[noteData+1] = false
-- 		for i = 0, getProperty('notes.length')-1 do
-- 			if getPropertyFromGroup('notes', i, 'isSustainNote') == true and getPropertyFromGroup('notes', i, 'noteData') == noteData then
-- 				setPropertyFromGroup('notes', i, 'ignoreNote', false); --Miss has no penalties
-- 				setPropertyFromGroup('notes', i, 'blockHit', false);
-- 			end
-- 		end
-- 	-- end
-- end

-- function noteMiss(id, direction, noteType, isSustainNote)
-- 	-- if not noteWasMiss[direction+1] then
-- 	-- 	noteWasMiss[direction+1] = true
-- 		for i = 0, getProperty('notes.length')-1 do
-- 			if getPropertyFromGroup('notes', i, 'isSustainNote') == true and getPropertyFromGroup('notes', i, 'noteData') == direction then
-- 				setPropertyFromGroup('notes', i, 'ignoreNote', true); --Miss has no penalties
-- 				setPropertyFromGroup('notes', i, 'blockHit', true);
-- 			end
-- 		end
-- 	-- end
-- end

-- -- function onUpdate(elapsed)
-- -- 	debugPrint(getRandomFloat(0.00, 1.00))
-- -- end