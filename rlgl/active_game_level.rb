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
    @window = window

    #@action_interval = 5.0
    @action_interval = level_info['action_interval'].to_f
    @time_to_next_action = Time.now + @action_interval
    @width = level_info['width'].to_i
    
    #@actions = [['move_right', 0],['jump',1],['pause',2]]
    @actions = level_info['actions']
    #@actions = [['move_right', 1]]

    @space = CP::Space.new()
    @space.gravity = vec2(0,980)
    @space.damping = 0.90
    @space.iterations = 20
    
    CP.bias_coef = 0.5

    @space.add_collision_func(:player, :goal) {|k,v,arb| @window.win_tag.play;@window.return_to_menu}
    @space.add_collision_func(:player, :damager) {|k,v,arb| @window.kill_player}
    #@platform = Platform.new(10, 400, 500, 800, 20, window)
    @platforms = Array.new
    @damagers = Array.new
    @props  = Array.new
    @spawners = Array.new
    @buttons = []
    unless level_info['entities']['platforms'].nil?
      level_info['entities']['platforms'].each do |r|
        next if r['w'].to_i.zero? or r['h'].to_i.zero?
        @platforms << j = Platform.new(@@mass, r, window)
        add_entity(j)
        add_entity(j.pin) unless j.pin.nil?
#      puts j.shape.bb
      end
    end
    @space.rehash_static
    unless level_info['entities']['damagers'].nil?
      level_info['entities']['damagers'].each do |r|
        next if r['w'].to_i.zero? or r['h'].to_i.zero?
        @damagers << j = Damager.new(@@mass, r, window)
        add_entity(j)
      end
    end
    unless level_info['entities']['buttons'].nil?
      level_info['entities']['buttons'].each do |r|
        next if r['w'].to_i.zero? or r['h'].to_i.zero?
        @buttons << j = Button.new(@@mass, r, window, @space, self)
        add_entity(j)
      end
    end
    unless level_info['entities']['spawners'].nil?
      level_info['entities']['spawners'].each do |r|
        next if r['w'].to_i.zero? or r['h'].to_i.zero?
        @spawners << j = ProjectileSpawn.new(@@mass, r, window, self)
        add_entity(j)
      end
    end
    
    g = level_info['entities']['goal']
    unless g.nil?
      @goal = Goal.new(@@mass, g, window) unless g['w'].to_i.zero? or g['h'].to_i.zero?
      add_entity(@goal)
    end
    @offset_x = 0
    #@platform_body = CP::Body.new_static()
    #@platform_body.p = vec2(0,500)
    #@platform_shape = CP::Shape::Poly.new(@platform_body, [vec2(0,0),vec2(0,20),vec2(600,20),vec2(600,0)])

    
    @bg_image = Gosu::Image.new(window, "#{$preface}media/background.jpg" )

    #add_entity(@platform)
#    @platform.body.velocity_func() {vec2(0,0)}
    @waiting = false
  end
  
  def rehash_shape(s)
    @space.rehash_shape(s)
  end
  
  def add_entity(e)
    @space.add_shape(e.shape)
    @space.add_body(e.body)
    e.shape.bb
  end
  
  def add_collision_func(s_1, s_2, &block)
    @space.add_collision_func(s_1, s_2, &block)
  end
  
  def add_collision_handler(s_1, s_2, handler)
    @space.add_collision_handler(s_1, s_2, handler)
  end
  
  def update(player)
    if !@waiting and Time.now >= @time_to_next_action
      # Do actions
      player.setup_actions(@actions)
      @waiting = true
    end
    @platforms.each do |r|
      if r.update(player)
        @space.rehash_shape(r.shape)
      end
    end
    @damagers.each do |r|
      if r.update(player)
        @space.rehash_shape(r.shape)
      end
    end
    @props.each do |r|
      if r.update(player)
        @space.rehash_shape(r.shape)
      end
    end
    @spawners.each do |r|
      if r.update
        @space.rehash_shape(r.shape)
      end
    end
    @buttons.each do |r|
      r.update(player)
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
    @damagers.each {|r| r.draw(self)}
    @buttons.each {|r| r.draw(self)}
    @spawners.each {|r| r.draw(self)}
    @goal.draw(self)
    color = 0x44ffffff
    @bg_image.draw_as_quad(0 - self.offset_x, 0, color, @width - self.offset_x, 0, color, @width - self.offset_x, 600, color, 0 - self.offset_x, 600, color, ZOrder::Background)
  end
  
  def find_entity_by_id(id)
    @platforms.select{|r| r.id == id}.first || @damagers.select{|r| r.id == id}.first || (@goal.id == id ? @goal : nil)
  end
end

class CustomSideHandler < CP::Arbiter
  def initialize(player)
    @player = player
  end
  
  def begin(a,b,arbiter)
    a.body.a = 0
    if arbiter.normal(0).y.round(1) == 1.0
      @player.can_jump = true
    end
    
    @player.normaled_objects |= [b]
    true
  end
  
  def separate(a,b)
    @player.normaled_objects -= [b]
  end

end
