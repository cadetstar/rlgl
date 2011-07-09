class ActiveGameLevel
  attr_reader :action_interval
  attr_reader :time_to_next_action
  attr_reader :player_in_control
  attr_reader :gravity
  attr_reader :actions
  attr_accessor :offset_x
  attr_reader :width
  @@mass = 10

  def initialize(level_info, window)
    #@action_interval = 5.0
    @action_interval = level_info['action_interval'].to_f
    @time_to_next_action = Time.now + @action_interval.to_f
    @width = level_info['width'].to_i
    
    #@actions = [['move_right', 0],['jump',1],['pause',2]]
    @actions = level_info['actions']
    #@actions = [['move_right', 1]]

    @space = CP::Space.new()
    @space.gravity = vec2(0,100)
    @space.damping = 0.95

    #@platform = Platform.new(10, 400, 500, 800, 20, window)
    @platforms = Array.new
    level_info['entities']['platforms'].each do |r|
      @platforms << j = Platform.new(@@mass, r['x'].to_i, window.height - r['y'].to_i, r['w'].to_i, r['h'].to_i, window)
      add_entity(j)
    end
    
    @offset_x = 0
    #@platform_body = CP::Body.new_static()
    #@platform_body.p = vec2(0,500)
    #@platform_shape = CP::Shape::Poly.new(@platform_body, [vec2(0,0),vec2(0,20),vec2(600,20),vec2(600,0)])

    
    #@image = Gosu::Image.new(window, './media/Starfighter.bmp')
    @bg_image = Gosu::Image.new(window, './media/grid.png' )

    #add_entity(@platform)
#    @platform.body.velocity_func() {vec2(0,0)}
    @waiting = false
  end
  
  def add_entity(e)
    @space.add_shape(e.shape)
    @space.add_body(e.body)
    e.shape.bb
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
    #@image.draw_as_quad(@platform_body.p.x + @platform_shape.vert(0).x,@platform_body.p.y + @platform_shape.vert(0).y,0xffffffff, @platform_body.p.x + @platform_shape.vert(1).x, @platform_body.p.y + @platform_shape.vert(1).y, 0xffffffff, @platform_body.p.x + @platform_shape.vert(2).x, @platform_body.p.y + @platform_shape.vert(2).y, 0xffffffff, @platform_body.p.x + @platform_shape.vert(3).x, @platform_body.p.y + @platform_shape.vert(3).y, 0xffffffff, ZOrder::Platforms)
    @platforms.each {|r| r.draw(self)}
    @bg_image.draw_as_quad(0, 0, 0xffffffff, 800, 0, 0xffffffff, 800, 600, 0xffffffff, 0, 600, 0xffffffff, ZOrder::Platforms - 1)
  end
end
