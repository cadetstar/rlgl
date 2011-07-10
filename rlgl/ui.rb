
class UI
  def initialize(actions, window)
    @timer_base = vec2(10,20)
    @ui_dim = vec2(400,100)
    @factor = 0.4
    @circle_size = 30
    @actions = actions.collect{|a| %w(jump jump_right jump_left move_right move_left).include?(a[0]) ? a[0] : nil}.compact
    @font = Gosu::Font.new(window, Gosu::default_font_name, 16)
    @timer_images = []
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_4.png", ZOrder::UI)
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_3.png", ZOrder::UI)
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_2.png", ZOrder::UI)
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_1.png", ZOrder::UI)
    
    @bgcolor = 0xff000000
  end
  
  def draw(game_level, window)
    
    window.draw_quad(0,0,@bgcolor, @ui_dim.x,0,@bgcolor, @ui_dim.x,@ui_dim.y,@bgcolor,0,@ui_dim.y,@bgcolor, ZOrder::UIBackground)
    @time_left = (game_level.time_to_next_action - Time.now).ceil
    if @time_left < 0
      @time_left = 0
    end
    t = @time_left
    @font.draw(t, 80, 80 - @font.height / 2.0, ZOrder::UIText, 1, 1, 0xffffffff)
    
    if t == 0
      @timer_images[0].draw(@timer_base.x, @timer_base.y, ZOrder::UI, @factor, @factor)
    elsif t < 4
      @timer_images[t-1].draw(@timer_base.x, @timer_base.y, ZOrder::UI, @factor, @factor)
    else
      @timer_images[3].draw(@timer_base.x, @timer_base.y, ZOrder::UI, @factor, @factor)
    end

    offset = 125
    space = 50
    pos_y = 50
    
    @actions.each_with_index do |a,i|
      pos_x = offset + i*space
      angle = case a
        when 'move_right'
          180
        when 'move_left'
          0
        when 'jump_right'
          135
        when 'jump'
          90
        when 'jump_left'
          45
        else
          270
      end
      window.rotate(angle, pos_x, pos_y) do
        window.draw_triangle(pos_x - 15, pos_y, 0xff00ff00, pos_x + 5, pos_y - 10, 0xff00ff00, pos_x + 5, pos_y + 10, 0xff00ff00, ZOrder::UI)
      end
    end
  end
  
end
