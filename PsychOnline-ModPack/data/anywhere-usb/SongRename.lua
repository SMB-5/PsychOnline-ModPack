--THIS SCRIPT ONLY EXISTS SO THAT YOUR HIGHSCORE CAN SAVE!!!!
function onEndSong()
	if not getPropertyFromClass('states.PlayState', 'chartingMode') then
		setPropertyFromClass('states.PlayState', 'SONG.song', 'Challeng-EDD');
	end
end