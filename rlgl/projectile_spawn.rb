class ProjectileSpawn < Prop
  attr_reader :projectiles
  def initialize(mass, detail_hash, window, game_level)
    super(mass, detail_hash, window)
    @projectiles = Array.new
    @phs = detail_hash['phs'].to_f
    @pvs = detail_hash['pvs'].to_f
    @pl = detail_hash['pl'].to_f
    @ttf = detail_hash['ttf'].to_f
    @pi = detail_hash['pi']
    @t = @ttf
    @window = window
    @game_level = game_level
  end

  def spawn
    @projectiles << e = Projectile.new(@body.p.x, @body.p.y, @phs, @pvs, @pl, @pi, @window)
    @game_level.add_entity(e)
  end

  def update
    @projectiles.each do |r|
      if r.driver.dead
        @game_level.remove_object(r)
        @projectiles.delete r
      else
        r.driver.update
        @game_level.rehash_shape(r.shape)
      end
    end
    @t -= 1.0/60
    if(@t < 0)
      spawn
      @t = @ttf
    end
  end
  
  def draw(game_level)
    super(game_level)
    @projectiles.each{|s| s.draw(game_level)}
  end
end

class Projectile
  attr_accessor :driver
  attr_accessor :body
  attr_accessor :shape
  def initialize(x, y, hs, vs, pl, pi, window)
    @body  = CP::Body.new_static()
    @body.velocity_func() { |body, gravity, damping, dt| vec2(0,0)}
    @x_size = 30
    @y_size = 30
    @body.p = vec2(x,y)
    @vecs = [vec2(-15,-15),vec2(-15,15),vec2(15,15),vec2(15,-15)]
    @shape = CP::Shape::Poly.new(@body, @vecs)
    @shape.collision_type = :damager
    @driver = ProjectileDriver.new(@body, @shape, hs, vs, pl)
    if File.exists?("#{$preface}media/#{pi}") and !File.directory?("#{$preface}media/#{pi}")
      @image = Gosu::Image.new(window, "#{$preface}media/#{pi}")
    else
      @image = Gosu::Image.new(window, "#{$preface}media/block.png")
    end
    
    @color = 0xffaaaaaa
  end
  def update
    @driver.update
  end
  def draw(game_level)
    @image.draw_as_quad(@body.p.x - game_level.offset_x + @shape.vert(0).x, @body.p.y + @shape.vert(0).y, @color,
                  @body.p.x - game_level.offset_x + @shape.vert(1).x, @body.p.y + @shape.vert(1).y, @color,
                  @body.p.x - game_level.offset_x + @shape.vert(2).x, @body.p.y + @shape.vert(2).y, @color,
                  @body.p.x - game_level.offset_x + @shape.vert(3).x, @body.p.y + @shape.vert(3).y, @color,
                  ZOrder::Platforms)
  end
end

class ProjectileDriver
  attr_reader :dead
  def initialize(body, shape, hs, vs, pl)
    @position = vec2(body.p.x,body.p.y)
    @base_position = vec2(body.p.x,body.p.y)
    @life = pl
    @body = body
    @shape = shape
    @hs = hs
    @vs = vs
    @dead = false
  end

  def update
    @position += vec2(@hs/60, @vs/60)
    @body.p = @position
    @life -= 1.0/60
    if(@life < 0)
      @dead = true
    end
  end
end