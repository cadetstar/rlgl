class Button < Entity
  # We have a button with a position and everything.
  # When it is impacted, we have some sort of action we do on something.  We hard code those values
  
  def initialize (mass, detail_hash, window, space, game_level)
    super(mass, detail_hash, window, false)
    self.shape.e = 0.0
    self.shape.u = 0.5
    a = self.shape.collision_type = "button_#{a ||= 0;a += 1}".to_sym
    @space = space
    space.add_collision_func(:player, a) {|k,v,arb| self.perform_button(game_level);false}


    @actor = detail_hash['actor']
    @action = detail_hash['action']
    @val1 = detail_hash['val1']
    @val2 = detail_hash['val2']
    @val3 = detail_hash['val3']
    @val4 = detail_hash['val4']
    @actor_entity = nil
  end
  
  def update
    super(player)
    if @actor_entity
      case @action
        when 'move_up'
          if @actor_entity.body.p.y > @val2.to_f
            @actor_entity.body.p.y -= @val1.to_f / 60.0
            if @actor_entity.body.p.y < @val2.to_f
              @actor_entity.body.p.y = @val2.to_f
            end
          end
        when 'move_down'
          if @actor_entity.body.p.y < @val2.to_f
            @actor_entity.body.p.y += @val1.to_f / 60.0
            if @actor_entity.body.p.y > @val2.to_f
              @actor_entity.body.p.y = @val2.to_f
            end
          end
      end
      @space.rehash_shape(@actor_entity.shape)
    end
  end
  
  def draw(game_level)
    super(game_level, ZOrder::Button)
  end
  
  
  def perform_button(game_level)
    puts "Hello?"
    @actor_entity = game_level.find_entity_by_id(@actor)
  end
end
