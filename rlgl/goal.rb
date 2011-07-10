class Goal < Entity
  def initialize(mass, detail_hash, window)
    detail_hash['i'] = "goal.png"
    detail_hash['r'] = 3.0
    super(mass, detail_hash, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    self.shape.collision_type = :goal
#    @color = 0xff00ff00
    @border = 2
    @rot = 1.0
  end
  
  def draw(game_level)
    super(game_level, ZOrder::Goal)
  end
end