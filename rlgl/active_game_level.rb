class ActiveGameLevel
  def initialize(level_info, window)
    @space = CP::Space.new()
    @platform_body = CP::Body.new_static()
    @platform_body.p = vec2(200,200)
    @platform_shape = CP::Shape::Poly.new(@platform_body, [vec2(-50,-50),vec2(-50,50),vec2(50,50),vec2(50,-50)])
    
    @image = Gosu::Image.new(window, './media/Starfighter.bmp')
    
    @space.add_body(@platform_body)
  end
  
  def draw
    puts 'reaching draw'
    @image.draw_as_quad(150,150,0xffffffff, 250, 150, 0xffffffff, 250, 250, 0xffffffff, 150, 250, 0xffffffff, ZOrder::Platforms)
  end
end
