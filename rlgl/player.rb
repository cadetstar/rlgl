class Player
  attr_reader :can_jump
  attr_reader :player_in_control
  @@walk_force = vec2(500,0)
  @@jump_force = vec2(0,-200)
  
  @@max_h = 200
  @@jolt_amt = 100
  
  def initialize(window, game_level)
    @body = CP::Body.new(200, CP.moment_for_box(200, 20,40))
    @body.w_limit = 0
    @body.p = vec2(200,200)
    
    verts = []
    verts << vec2(-25,-50)
    verts << vec2(-25,50)
    verts << vec2(25,50)
    verts << vec2(25,-50)
    
    @shape = CP::Shape::Poly.new(@body, verts)
    @shape.e = 0.0
    @shape.u = 0.5
    @shape.collision_type = :player
    
    game_level.add_entity(@shape, @body)
    game_level.add_collision_func(:player, :platform) {@can_jump = true}
    
    @player_image = Gosu::Image.new(window, './media/Starfighter.bmp')
    @can_jump = true
    @actions = []
    @player_in_control = true
  end
  
  def update(game_level)
    unless @player_in_control
      unless @actions.empty?
        if Time.now > @actions[0][0]
          self.perform_action(@actions[0][1])
          @actions = @actions[1..-1]
        end
      else
        @player_in_control = true
        game_level.finished_actions
      end
    end
    
    if @body.v.x > @@max_h
      @body.v.x = @@max_h
    end
    if @body.v.x < -@@max_h
      @body.v.x = -@@max_h
    end
  end
  
  def setup_actions(actions)
    @actions = []
    actions.each do |act,t|
      @actions << [Time.now + t, act]
    end
    @player_in_control = false
  end
  
  def perform_action(action)
    case action
      when 'jump'
        jump(true)
      when 'jump_right'
        jolt_right
        jump(true)
      when 'jump_left'
        jolt_left
        jump(true)
      when 'move_right'
        jolt_right
      when 'move_left'
        jolt_left
    end
  end
  
  def draw
    @player_image.draw_rot(@body.p.x,@body.p.y, ZOrder::Player, 0)
  end
  
  def jolt_right
    @body.v.x = @@jolt_amt
  end
  
  def jolt_left
    @body.v.x = -@@jolt_amt
  end
  
  def jump(override = false)
    if @can_jump or override
      @body.v += @@jump_force
      @can_jump = false
    end
    #@body.apply_force(@@jump_force, vec2(0,0))
  end
  
  def move_right
    @body.apply_impulse(@@walk_force, vec2(0,0))
  end
  
  def move_left
    @body.apply_impulse(-@@walk_force, vec2(0,0))
  end
  
end
