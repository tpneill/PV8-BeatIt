LoadScript("music")
LoadScript("code-globals")
LoadScript("code-utils")
LoadScript("code-playing")
LoadScript("code-ended")

function Init()
  BackgroundColor(0)
  local display = Display()
  SetEndTime()
  stateToPlaying()
end

function Update(timeDelta)
  gameContext.updateFunc(timeDelta)
end

function Draw()
  gameContext.drawFunc()
end
