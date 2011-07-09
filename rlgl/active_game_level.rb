class ActiveGameLevel
  attr_reader :action_interval
  attr_reader :time_to_next_action
  attr_reader :player_in_control
  attr_reader :gravity
  attr_reader :actions
  
  def initialize(level_info, window)
    @action_interval = 5.0
    @time_to_next_action = Time.now + @action_interval
    @actions = [['move_right', 0],['jump',1],['pause',2]]
    
    @space = CP::Space.new()
    @space.gravity = vec2(0,100)
    @space.damping = 0.95
    
    @platform_body = CP::Body.new_static()
    @platform_body.p = vec2(0,500)
    @platform_shape = CP::Shape::Poly.new(@platform_body, [vec2(0,0),vec2(0,20),vec2(600,20),vec2(600,0)])
    @platform_body.velocity_func() { |body, gravity, damping, dt| vec2(0,0)}
    
    @platform_shape.e = 0.0
    @platform_shape.u = 0.5
    @platform_shape.collision_type = :platform
    
    @image = Gosu::Image.new(window, './media/Starfighter.bmp')
    
    @space.add_body(@platform_body)
    @space.add_shape(@platform_shape)
    @waiting = false
  end
  
  def add_entity(shape, body)
    @space.add_shape(shape)
    @space.add_body(body)
  end
  
  def add_collision_func(s_1, s_2, &block)
    @space.add_collision_func(s_1, s_2, &block)
  end
  
  def update(player)
    if !@waiting and Time.now >= @time_to_next_action
      # Do actions
      player.setup_actions(@actions)
      @waiting = true
    end
    @space.step(1.0/60)
  end
  
  def finished_actions
    @time_to_next_action = Time.now + @action_interval
    @waiting = false
  end
  
  def draw
    @image.draw_as_quad(@platform_body.p.x + @platform_shape.vert(0).x,@platform_body.p.y + @platform_shape.vert(0).y,0xffffffff, @platform_body.p.x + @platform_shape.vert(1).x, @platform_body.p.y + @platform_shape.vert(1).y, 0xffffffff, @platform_body.p.x + @platform_shape.vert(2).x, @platform_body.p.y + @platform_shape.vert(2).y, 0xffffffff, @platform_body.p.x + @platform_shape.vert(3).x, @platform_body.p.y + @platform_shape.vert(3).y, 0xffffffff, ZOrder::Platforms)
  end
end
