function UpdateEnded(timeDelta)
  -- Do nothing
end

function DrawEnded()
  RedrawDisplay()
  DrawRect(0, 0, 264, 248, 0, DrawMode.TilemapCache)
  DrawRect(0, 64, 264, 42, 15, DrawMode.TilemapCache)
  DrawText("Track Complete", 74, 82, DrawMode.Sprite, "large", 0)
  DrawText("Score", 110, 125, DrawMode.Sprite, "small", 3)
  DrawText(gameContext.score, 110, 136, DrawMode.Sprite, "large", 14)
end
