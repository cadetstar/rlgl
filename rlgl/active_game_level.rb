class ActiveGameLevel
  attr_reader :action_interval
  attr_reader :time_to_next_action
  attr_reader :player_in_control
  attr_reader :gravity
  
  def initialize(level_info, window)
    @action_interval = 10.0
    @time_to_next_action = Time.now + @action_interval
    
    @space = CP::Space.new()
    @platform_body = CP::Body.new_static()
    @platform_body.p = vec2(200,200)
    @platform_shape = CP::Shape::Poly.new(@platform_body, [vec2(-50,-50),vec2(-50,50),vec2(50,50),vec2(50,-50)])
    
    @image = Gosu::Image.new(window, './media/Starfighter.bmp')
    
    @space.add_body(@platform_body)
  end
  
  def update
    if Time.now >= @time_to_next_action
      # Do actions
      @time_to_next_action = Time.now + @action_interval
    end
  end
  
  
  def draw
    @image.draw_as_quad(150,150,0xffffffff, 250, 150, 0xffffffff, 250, 250, 0xffffffff, 150, 250, 0xffffffff, ZOrder::Platforms)
  end
end
