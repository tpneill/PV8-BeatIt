function SetEndTime()
  for i, note in ipairs(musicNotes) do
    gameContext.endTime = note[1]
  end
end

function stateToPlaying()
  PlaySong(0, false)
  gameContext.state = gameStates.Playing
  gameContext.drawFunc = DrawPlaying
  gameContext.updateFunc = UpdatePlaying
end

function stateToEnded()
  StopSong()
  gameContext.state = gameStates.Ended
  gameContext.drawFunc = DrawEnded
  gameContext.updateFunc = UpdateEnded
end
