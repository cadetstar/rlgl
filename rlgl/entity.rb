class Entity
  attr_accessor :shape
  attr_accessor :body
  attr_accessor :image
  attr_reader :pin
  attr_reader :id
  def initialize (mass, detail_hash, window, movable = true)
    x_pos = detail_hash['x'].to_i
    y_pos = window.height - detail_hash['y'].to_i
    x_size = detail_hash['w'].to_i
    y_size = detail_hash['h'].to_i
    hs = detail_hash['hs'].to_f
    vs = detail_hash['vs'].to_f
    ht = detail_hash['ht'].to_i
    vt = detail_hash['vt'].to_i
    
    if movable or !hs.to_f.zero? or !vs.to_f.zero?
#      @body  = CP::Body.new(mass, CP::INFINITY)#CP.moment_for_box(mass, x_size, y_size))
    else
    end
    @body  = CP::Body.new_static()
    @body.velocity_func() { |body, gravity, damping, dt| vec2(0,0)}
    @x_size = x_size
    @y_size = y_size
    x_off = @x_size / 2.0
    y_off = @y_size / 2.0
    
    @driver = nil
    
    @id = detail_hash['id'].to_s
    @body.p = vec2(x_pos + x_off, y_pos - y_off)
    @vecs = Array.new
    @vecs = [vec2(-x_off,-y_off),vec2(-x_off,y_off),vec2(x_off,y_off),vec2(x_off,-y_off)]
    @rot = detail_hash['r'].to_i
    
    @shape = CP::Shape::Poly.new(@body, @vecs.rotate(@rot))
    @shape.e = 0.0
    @shape.bb
    if File.exists?("#{$preface}media/#{detail_hash['i']}") and !File.directory?("#{$preface}media/#{detail_hash['i']}")
      @image = Gosu::Image.new(window, "#{$preface}media/#{detail_hash['i']}")
    else
      @image = Gosu::Image.new(window, "#{$preface}media/block.png")
    end
    @color = 0xffaaaaaa
    unless hs.to_f.zero? and vs.to_f.zero?
      @driver = EntityDriver.new(@body, @shape, hs, vs, ht, vt)
    end
    @rot = 0.0
  end

  def update(player)
    if @driver
      @driver.update(player)
    end
  end

  def draw(game_level, zorder=ZOrder::Platforms)
#    $w.rotate(@rot*90, @body.p.x - game_level.offset_x,@body.p.y) do
    @image.draw_as_quad(@body.p.x - game_level.offset_x + @shape.vert(0).x, @body.p.y + @shape.vert(0).y, @color,
                        @body.p.x - game_level.offset_x + @shape.vert(1).x, @body.p.y + @shape.vert(1).y, @color,
                        @body.p.x - game_level.offset_x + @shape.vert(2).x, @body.p.y + @shape.vert(2).y, @color,
                        @body.p.x - game_level.offset_x + @shape.vert(3).x, @body.p.y + @shape.vert(3).y, @color,
                        zorder)
                        #end
  end
end

class EntityDriver
  def initialize(body, shape, hs, vs, ht, vt)
    @position = vec2(body.p.x,body.p.y)
    @base_position = vec2(body.p.x,body.p.y)
    
    @body = body
    @shape = shape
    @hs = hs
    @vs = vs
    @ht = ht
    @vt = vt
    @hsign = 1
    @vsign = 1
  end
  
  def update(player)
    if player.normaled_objects.include?(@shape)
      start_y = @position.y
      start_x = @position.x
    else
      start_y = nil
    end
    
    @position += vec2(@hs*@hsign/60, @vs*@vsign/60)
    if @position.x > @base_position.x + @ht / 2.0
      @position.x = @base_position.x + @ht/2.0
      @hsign = -1
    elsif @position.x < @base_position.x - @ht / 2.0
      @position.x = @base_position.x - @ht / 2.0
      @hsign = 1
    end
    
    if @position.y > @base_position.y + @vt / 2.0
      @position.y = @base_position.y + @vt/2.0
      @vsign = -1
    elsif @position.y < @base_position.y - @vt/2.0
      @position.y = @base_position.y - @vt/2.0
      @vsign = 1
    end
    @body.p = @position
    if start_y
      player.shape.body.p.y += @position.y - start_y
      player.shape.body.p.x += @position.x - start_x
    end
    true
  end
end

    