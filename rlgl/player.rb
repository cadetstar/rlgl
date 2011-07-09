class Player
  attr_reader :can_jump
  
  def initialize
    @body = CP::Body.new(200, CP.moment_for_box(200, 20,40))
    @body.v_limit = 20
    @body.w_limit = 0
  end
  
  def update
  end
  
  def draw(game_level)
#    @body.update_velocity
  end
  
  def jump(override = false)
    @body.v.y += 20
  end
  
  def move_right
    @body.v.x += 20
  end
  
  def move_left
    @body.v.x -= 20
  end
  
end
