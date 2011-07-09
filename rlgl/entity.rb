class Entity
  attr_reader :shape
  attr_accessor :body
  def initialize (mass, x_pos, y_pos, x_size, y_size, window)
    @body  = CP::Body.new(mass, 0)
    @body.p = vec2(x_pos, y_pos)
    @x_size = x_size
    @y_size = y_size
    @vecs = Array.new
    @vecs << vec2(-1* x_size/2, y_size/2)
    @vecs << vec2(x_size/2, y_size/2)
    @vecs << vec2(x_size/2, -1* y_size/2)
    @vecs << vec2(-1*x_size/2, -1* y_size/2)
    @shape = CP::Shape::Poly.new(@body, @vecs)
    @image = Gosu::Image.new(window, './media/block.png')
    @color = 0xaaaaaaaa
  end

  def update

  end

  def draw
    @image.draw_as_quad(@body.p.x + @vecs[0].x, @body.p.y + @vecs[0].y, @color,
                        @body.p.x + @vecs[1].x, @body.p.y + @vecs[1].y, @color,
                        @body.p.x + @vecs[2].x, @body.p.y + @vecs[2].y, @color,
                        @body.p.x + @vecs[3].x, @body.p.y + @vecs[3].y, @color,
                        ZOrder::Platforms)
  end
end