class Goal < Entity
  def initialize(mass, detail_hash, window)
    detail_hash['i'] = "goal.png"
    super(mass, detail_hash, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    self.shape.collision_type = :goal
    @color = 0xff00ff00
    @border = 2
  end
  
  def draw(game_level)
    super(game_level, ZOrder::Goal)
    #puts @body.p.x - game_level.offset_x + @shape.vert(2).x - @border
    #puts ZOrder::GoalBorder
    $w.draw_quad(@body.p.x - game_level.offset_x + @shape.vert(0).x - @border, @body.p.y + @shape.vert(0).y - @border, 0xff00ff00,
                        @body.p.x - game_level.offset_x + @shape.vert(1).x - @border, @body.p.y + @shape.vert(1).y + @border, 0xff00ff00,
                        @body.p.x - game_level.offset_x + @shape.vert(2).x + @border, @body.p.y + @shape.vert(2).y + @border, 0xff00ff00,
                        @body.p.x - game_level.offset_x + @shape.vert(3).x + @border, @body.p.y + @shape.vert(3).y - @border, 0xff00ff00,
                        ZOrder::GoalBorder)
  end
    
end