class ProjectileSpawn < Prop
  attr_reader :projectiles
  def initialize(mass, detail_hash, window)
    super(mass, detail_hash, window)
    @projectiles = Array.new
    @phs = detail_hash['phs'].to_f
    @pvs = detail_hash['pvs'].to_f
    @pl = detail_hash['pl'].to_f
    @ttf = detail_hash['ttf'].to_f
    @pi = detail_hash['pi']
    @t = @ttf
  end

  def spawn
    @projectiles << e = Projectile.new(@body.p.x, @body.p.y, @phs, @pvs, @pl, @pi)
    @window.space.add_body(e.body)
    @window.space.add_shape(e.shape)
  end

  def update
    @projectiles.each do |r|
      if r.dead
        @window.space.remove_body r.body
        @window.space.remove_shape r.shape
        @projectiles.delete r
      end
    end
    @t -= 1.0/60
    if(@t < 0)
      spawn
      @t = @ttf
    end
  end
end

class Projectile
  attr_accessor :driver
  attr_accessor :body
  attr_accessor :shape
  def initialize(x, y, hs, vs, pl, pi)
    @body  = CP::Body.new_static()
    @body.velocity_func() { |body, gravity, damping, dt| vec2(0,0)}
    @x_size = 30
    @y_size = 30
    @body.p = vec2(x,y)
    @vecs = [vec2(-15,-15),vec2(15,-15),vec2(15,15),vec2(-15,15)]
    @shape = CP::Shape::Poly.new(@body, @vecs)
    @driver = ProjectileDriver.new(@body, @shape, hs, vs, pl)
    @image = Gosu::Image.new(window, "#{$preface}media/#{pi}")
  end
  def update
    @driver.update
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