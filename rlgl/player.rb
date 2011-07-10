class Player < Entity
  attr_reader :player_in_control
  attr_accessor :can_jump
  attr_reader :shape
  
  @@walk_force = vec2(500,0)
  @@jump_force = vec2(0,-340)
  
  @@max_h = 500
  @@jolt_amt = 300
  @@slow_down = 0.1

  @@max_player_x = 100
  
  def initialize(window, game_level, start_pos = {'x' => 200, 'y' => 200})
    @body = CP::Body.new(200, CP.moment_for_box(200, 50,80))
    @body.w_limit = 0
    width = 50
    height = 80
    @body.p = vec2(start_pos['x'].to_i + width/2.0,window.height - start_pos['y'].to_i - height/2.0)
    
    verts = []
    
    verts << vec2(-width/2.0,-height/2.0)
    verts << vec2(-width/2.0,height/2.0)
    verts << vec2(width/2.0,height/2.0)
    verts << vec2(width/2.0,-height/2.0)
    
    @shape = CP::Shape::Poly.new(@body, verts)
    @shape.e = 0.0
    @shape.u = 0.2
    @shape.collision_type = :player
    
    game_level.add_entity(self)
    game_level.add_collision_handler(:player, :platform, CustomSideHandler.new(self))
    
    @player_image = Gosu::Image.new(window, './media/player.png')
    @can_jump = true
    @actions = []
    @player_in_control = true
  end
  
  def update(game_level)
    if @body.p.y > $w.height + 50
      $w.return_to_menu
      return
    end

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

    if @player_in_control
      if @body.v.x > @@max_player_x
        @body.v.x = [@body.v.x - @@slow_down, @@max_player_x].max
      end
      if @body.v.x < -@@max_player_x
        @body.v.x = [@body.v.x + @@slow_down, -@@max_player_x].min
      end
    else
      if @body.v.x > @@max_h
        @body.v.x = [@body.v.x - @@slow_down, @@max_h].max
      end
      if @body.v.x < -@@max_h
        @body.v.x = [@body.v.x + @@slow_down, -@@max_h].min
      end
    end

    
    movement = 0
    diff = @body.p.x - game_level.offset_x - $w.width / 2.0
    right_side = (game_level.width - game_level.offset_x) - $w.width
    left_side = game_level.offset_x
    
    if diff > 0 and right_side > 0
      movement = [diff, right_side].min
    elsif diff < 0 and left_side > 0
      movement = [diff,-left_side].max
    end
    game_level.offset_x += movement
  end
  
  def setup_actions(actions)
    @actions = []
    actions.each do |act,t|
      @actions << [Time.now + t.to_f, act]
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
  
  def draw(game_level)
    color = 0xff0000ff
    #@player_image.draw_rot(@body.p.x - game_level.offset_x,@body.p.y, ZOrder::Player, 0)
    $w.draw_quad(@body.p.x - game_level.offset_x + @shape.vert(0).x, @body.p.y + @shape.vert(0).y, color,
                        @body.p.x - game_level.offset_x + @shape.vert(1).x, @body.p.y + @shape.vert(1).y, color,
                        @body.p.x - game_level.offset_x + @shape.vert(2).x, @body.p.y + @shape.vert(2).y, color,
                        @body.p.x - game_level.offset_x + @shape.vert(3).x, @body.p.y + @shape.vert(3).y, color, ZOrder::Player)
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
    pre_max = @body.v.x
    @body.apply_impulse(@@walk_force, vec2(0,0))
    if @body.v.x > @@max_player_x
      @body.v.x = pre_max
    end
  end
  
  def move_left
    pre_max = @body.v.x
    @body.apply_impulse(-@@walk_force, vec2(0,0))
    if @body.v.x < -@@max_player_x
      @body.v.x = pre_max
    end
  end
  
end
