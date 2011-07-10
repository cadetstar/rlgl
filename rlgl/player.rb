class Player < Entity
  attr_reader :player_in_control
  attr_accessor :can_jump
  attr_reader :shape
  attr_accessor :normaled_objects
  attr_reader :current_action
  
  @@walk_force = vec2(500,0)  
  @@jump_force = vec2(0,-500)
  @@braking_force = vec2(1500,0)
  
  @@max_h = 500
  @@jolt_amt = 800
  @@jolt_less = 0.6
  @@slow_down = 0.1
  @@min_x = 50
  @@super_jump_modifier = 1.5

  @@max_player_x = 300
  
  def initialize(window, game_level, start_pos = {'x' => 200, 'y' => 200})
    @body = CP::Body.new(200, CP.moment_for_box(200, 50,80))
    @body.w_limit = 0
    width = 50
    height = 80
    @body.p = vec2(start_pos['x'].to_i + width/2.0,window.height - start_pos['y'].to_i - height/2.0)
    
    @normaled_objects = []
    verts = []
    
    verts << vec2(-width/2.0,-height/2.0)
    verts << vec2(-width/2.0,height/2.0)
    verts << vec2(width/2.0,height/2.0)
    verts << vec2(width/2.0,-height/2.0)
    
    @shape = CP::Shape::Poly.new(@body, verts)
    @shape.e = 0.0
    @shape.u = 0.0
    @shape.collision_type = :player
    
    game_level.add_entity(self)
    game_level.add_collision_handler(:player, :platform, CustomSideHandler.new(self))
    game_level.add_collision_handler(:player, :none, NoHandler.new)
    
    @player_image = Gosu::Image.new(window, "#{$preface}media/player.png")
    @can_jump = true
    @actions = []
    @player_in_control = true
    @current_action = nil
  end
  
  def update(game_level)
    if @body.p.y > $w.height + 50
      $w.kill_player
      return
    end

    unless @player_in_control
      unless @actions.empty?
        if Time.now > @actions[0][0]
          @current_action ||= -1
          @current_action += 1
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
      if @body.v.x.abs < 5.0
        @body.v.x = 0.0
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
    @current_action = -1
    actions.sort_by{|a,b| b}.each do |act,t|
      @actions << [Time.now + t.to_f, act]
    end
    @player_in_control = false
  end
  
  def perform_action(action)
    case action
      when 'jump'
        jump(true)
      when 'super_jump'
        jump(true, @@super_jump_modifier)
      when 'jump_right'
        jolt_right(@@jolt_less)
        jump(true)
      when 'jump_left'
        jolt_left(@@jolt_less)
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
  
  def jolt_right(mod = 1.0)
    @body.v.x = @@jolt_amt * mod
  end
  
  def jolt_left(mod = 1.0)
    @body.v.x = -@@jolt_amt * mod
  end
  
  def jump(override = false, double=1.0)
    if @can_jump or override
      @body.v.y = @@jump_force.y * double
      @can_jump = false
    end
    #@body.apply_force(@@jump_force, vec2(0,0))
  end
  
  def move_right
    if @body.v.x > 0
      if @body.v.x < @@min_x
        @body.v.x = @@min_x
      end
      pre_max = @body.v.x
      @body.apply_impulse(@@walk_force, vec2(0,0))
      if @body.v.x > @@max_player_x
        @body.v.x = pre_max
      end
    else
      @body.apply_impulse(@@braking_force, vec2(0,0))
    end
  end
  
  def move_left
    if @body.v.x < 0
      if @body.v.x > -@@min_x
        @body.v.x = -@@min_x
      end
      pre_max = @body.v.x
      @body.apply_impulse(-@@walk_force, vec2(0,0))
      if @body.v.x < -@@max_player_x
        @body.v.x = pre_max
      end
    else
      @body.apply_impulse(-@@braking_force, vec2(0,0))
    end
  end
  
end

class NoHandler
  def begin(a,b, arb)
    false
  end
end
