
absTime = 0
gameRunning = 1

musicNotes = {
  { 1260, 1 },
  { 1540, 1 },
  { 1820, 2 },
  { 2380, 1 },
  { 2660, 1 },
  { 2940, 2 },
  { 3500, 1 },
  { 3780, 1 },
  { 4060, 2 },
  { 4620, 1 },
  { 4900, 1 },
  { 5180, 2 },
  { 5740, 1 },
  { 6020, 1 },
  { 6300, 2 },
  { 6860, 1 },
  { 7140, 1 },
  { 7420, 2 },
  { 7980, 1 },
  { 8260, 1 },
  { 8540, 2 },
  { 9100, 1 },
  { 9380, 1 },
  { 9660, 2 },
  { 10220, 1 },
  { 10500, 1 },
  { 10780, 2 },
  { 11340, 1 },
  { 11620, 1 },
  { 11900, 2 },
  { 12460, 1 },
  { 12740, 1 },
  { 13020, 2 },
  { 13580, 1 },
  { 13860, 1 },
  { 14140, 2 },
  { 14700, 1 },
  { 14980, 1 },
  { 15260, 2 },
  { 15820, 1 },
  { 16100, 1 },
  { 16380, 2 },
  { 16940, 1 },
  { 17220, 1 },
  { 17500, 2 },
  { 18060, 1 },
  { 18340, 1 },
  { 18620, 2 },
  { 19180, 1 },
  { 19460, 1 },
  { 19740, 2 },
  { 20300, 1 },
  { 20580, 1 },
  { 20860, 2 },
  { 21420, 1 },
  { 21700, 1 },
  { 21980, 2 },
  { 22540, 1 },
  { 22820, 1 },
  { 23100, 2 },
  { 23660, 1 },
  { 23940, 1 },
  { 24220, 2 },
  { 24780, 1 },
  { 25060, 1 },
  { 25340, 2 },
  { 25900, 1 },
  { 26180, 1 },
  { 26460, 2 },
  { 28000, -1 }
}
drawNotes = {}
speedFactor = 4
score = 0
noinput = 1
acceptableRange = 60
perfectRange = 20
buttonTable ={
  a=0, b=0
}
scope = ""

manualOffset = 90

debug = 1

endTime = -1

function SetEndTime()
  for i, note in ipairs(musicNotes) do
    endTime = note[1]
  end
end

function Init()
  BackgroundColor(0)
  local display = Display()
  SetEndTime()
  PlaySong(0, false)
end



function Update(timeDelta)
  absTime = absTime + timeDelta

  -- Figure out what notes should be drawn on screen
  drawNotes = {}
  for i, note in ipairs(musicNotes) do
    xpos = (note[1] - absTime) / speedFactor
    if xpos > -16 and xpos < 264 then
      if note[2] == 1 then
        spriteId = 0
      elseif note[2] == 2 then
        spriteId = 2
      else
        spriteId = -1
      end

      if spriteId != -1 then
        table.insert(drawNotes, { xpos, spriteId, note[1], note[2] })
      end
    end

    if note[1] < absTime and note[2] < 0 then
       gameRunning = 0
       StopSong()
    end
  end

  -- Find an eligable notes
  scope = ""
  scorePotential = 0
  noteType = 0

  for i, note in ipairs(drawNotes) do
    diffTime = math.abs(note[3] - absTime - manualOffset)
    if diffTime < perfectRange then
      scope = "-"
      scorePotential = 1000
      noteType = note[4]
    elseif diffTime < acceptableRange then
      scope = "+"
      scorePotential = 250
      noteType = note[4]
    end
  end

  if Button(Buttons.A, InputState.Down, 0) then
    if buttonTable.a == 0 then
      if scorePotential > 0 and noteType == 1 then
        PlaySound(10)
        score = score + scorePotential
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
        score = score + scorePotential
      end
    end
    buttonTable.b = 1
  else
    buttonTable.b = 0
  end


end

function Draw()
  if gameRunning == 1 then
    DrawGame()
  else
    DrawEnd()
  end

end

function DrawEnd()
  RedrawDisplay()
  DrawRect(0, 0, 264, 248, 0, DrawMode.TilemapCache)
  DrawRect(0, 64, 264, 42, 15, DrawMode.TilemapCache)
  DrawText("Track Complete", 74, 82, DrawMode.Sprite, "large", 0)
  DrawText("Score", 110, 125, DrawMode.Sprite, "small", 3)
  DrawText(score, 110, 136, DrawMode.Sprite, "large", 14)
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
  if absTime < endTime then
    DrawRect(4, 228, absTime / endTime * 250, 8, 6, DrawMode.TilemapCache)
  end

  -- score
  DrawRect(2, 2, 84, 12, 0, DrawMode.TilemapCache)
  DrawRect(2, 14, 39, 8, 0, DrawMode.TilemapCache)
  DrawText("Score", 4, 14, DrawMode.Sprite, "small", 3)
  DrawText(score, 4, 4, DrawMode.Sprite, "large", 14)

  -- debug stuff
  if debug == 1 then
    DrawText(absTime, 8, 200, DrawMode.Sprite, "large", 14)
    DrawText(scope, 64, 200, DrawMode.Sprite, "large", 14)
  end
end

function DrawGame()
  RedrawDisplay()
  DrawGameUI()

  -- Draw each of the visible notes on screen
  for i, note, time in ipairs(drawNotes) do
    DrawSpriteBlock(note[2], note[1], 100, 2, 2, false, false, DrawMode.SpriteAbove)
  end

  -- Draw the note target
  DrawSpriteBlock(32, 8, 84, 5, 5, false, false, DrawMode.SpriteAbove)
end
