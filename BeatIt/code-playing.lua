function UpdatePlaying(timeDelta)
  gameContext.absTime = gameContext.absTime + timeDelta

  -- Figure out what notes should be drawn on screen
  gameContext.drawNotes = {}
  for i, note in ipairs(musicNotes) do
    xpos = (note[1] - gameContext.absTime) / gameHacks.speedFactor
    if xpos > -16 and xpos < 264 then
      if note[2] == 1 then
        spriteId = 0
      elseif note[2] == 2 then
        spriteId = 2
      else
        spriteId = -1
      end

      if spriteId != -1 then
        table.insert(gameContext.drawNotes, { xpos, spriteId, note[1], note[2] })
      end
    end

    if note[1] < gameContext.absTime and note[2] < 0 then
       stateToEnded()
    end
  end

  -- Find an eligable notes
  debugElements.scope = ""
  scorePotential = 0
  noteType = 0

  for i, note in ipairs(gameContext.drawNotes) do
    diffTime = math.abs(note[3] - gameContext.absTime - gameHacks.manualOffset)
    if diffTime < gameSettings.perfectRange then
      debugElements.scope = " - "
      scorePotential = 1000
      noteType = note[4]
    elseif diffTime < gameSettings.acceptableRange then
      debugElements.scope = "---"
      scorePotential = 250
      noteType = note[4]
    end
  end

  if Button(Buttons.A, InputState.Down, 0) then
    if buttonTable.a == 0 then
      if scorePotential > 0 and noteType == 1 then
        PlaySound(10)
        gameContext.score = gameContext.score + scorePotential
      end
    end
    buttonTable.a = 1
  else
    buttonTable.a = 0
  end

  if Button(Buttons.B, InputState.Down, 0) then
    if buttonTable.b == 0 then
      if scorePotential > 0 and noteType == 2 then
        PlaySound(11)
        gameContext.score = gameContext.score + scorePotential
      end
    end
    buttonTable.b = 1
  else
    buttonTable.b = 0
  end

end


function DrawGameUI()
  -- White bar for the note chart to scroll over
  DrawRect(0, 64, 264, 84, 15, DrawMode.TilemapCache)
  DrawRect(0, 149, 264, 99, 8, DrawMode.TilemapCache)

  -- Blue stuff at the top
  DrawRect(0, 0, 256, 16, 3, DrawMode.TilemapCache)
  DrawRect(0, 16, 256, 16, 2, DrawMode.TilemapCache)
  DrawRect(0, 32, 256, 16, 1, DrawMode.TilemapCache)

  -- Progress meter
  DrawRect(2, 218, 63, 8, 0, DrawMode.TilemapCache)
  DrawRect(2, 226, 252, 12, 0, DrawMode.TilemapCache)
  DrawText("Progress", 4, 218, DrawMode.Sprite, "small", 3)
  if gameContext.absTime < gameContext.endTime then
    DrawRect(4, 228, gameContext.absTime / gameContext.endTime * 250, 8, 6, DrawMode.TilemapCache)
  end

  -- score
  DrawRect(2, 2, 84, 12, 0, DrawMode.TilemapCache)
  DrawRect(2, 14, 39, 8, 0, DrawMode.TilemapCache)
  DrawText("Score", 4, 14, DrawMode.Sprite, "small", 3)
  DrawText(gameContext.score, 4, 4, DrawMode.Sprite, "large", 14)

  -- debug stuff
  if debug == 1 then
    DrawText(gameContext.absTime, 8, 200, DrawMode.Sprite, "large", 14)
    DrawText(debugElements.scope, 64, 200, DrawMode.Sprite, "large", 14)
  end
end

function DrawPlaying()
  RedrawDisplay()
  DrawGameUI()

  -- Draw each of the visible notes on screen
  for i, note, time in ipairs(gameContext.drawNotes) do
    DrawSpriteBlock(note[2], note[1], 100, 2, 2, false, false, DrawMode.SpriteAbove)
  end

  -- Draw the note target
  DrawSpriteBlock(32, 8, 84, 5, 5, false, false, DrawMode.SpriteAbove)
end
