class Entity
  attr_reader :shape
  attr_accessor :body
  def initialize(mass, xPos, yPos, xSize, ySize)
    @body  = CP::Body.new()
    @body.m = mass;
    @body.p = vec2(xPos, yPos)
    @xSize = xSize
    @ySize = ySize
    @vecs = Array.new
    @vecs << vec2(xPos - xSize/2, yPos + ySize/2)
    @vecs << vec2(xPos + xSize/2, yPos + ySize/2)
    @vecs << vec2(xPos - xSize/2, yPos - ySize/2)
    @vecs << vec2(xPos + xSize/2, yPos - ySize/2)
    @shape = CP::Shape::Poly.new(@body, vec_array)
    @image = Gosu::Image.new(window, './media/block.png')
    @color = 0xaaaaaaaa
  end

  def update

  end

  def draw
    @image.draw_as_quad(@vecs[0].x, @vecs[0].y, @color,
                        @vecs[1].x, @vecs[1].y, @color,
                        @vecs[2].x, @vecs[2].y, @color,
                        @vecs[3].x, @vecs[3].y, @color,
                        ZOrder::Platforms)
  end
end