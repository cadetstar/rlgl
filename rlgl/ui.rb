
class UI
  def initialize(actions, window)
    @timer_base = vec2(10,20)
    @ui_dim = vec2(400,100)
    @factor = 1.0
    @circle_size = 30
    @actions = actions.collect{|a| %w(jump jump_right jump_left move_right move_left pause super_jump).include?(a[0]) ? a : nil}.compact.sort_by{|a| a[1]}
    @font = Gosu::Font.new(window, Gosu::default_font_name, 16)
    @timer_images = []
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_4.png")
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_3.png")
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_2.png")
    @timer_images << Gosu::Image.new(window, "#{$preface}media/wifi_1.png")
    
    @straight_arrow = [Gosu::Image.new(window, "#{$preface}media/ArrowR.png"), Gosu::Image.new(window, "#{$preface}media/ArrowRGlow.png")]
    @jump_right_arrow = [Gosu::Image.new(window, "#{$preface}media/ArrowJR.png"), Gosu::Image.new(window, "#{$preface}media/ArrowJRGlow.png")]
    @jump_left_arrow = [Gosu::Image.new(window, "#{$preface}media/ArrowJL.png"), Gosu::Image.new(window, "#{$preface}media/ArrowJLGlow.png")]
    @super_jump_arrow = [Gosu::Image.new(window, "#{$preface}media/ArrowSuperJ.png"), Gosu::Image.new(window, "#{$preface}media/ArrowSuperJGlow.png")]
    
    @frame = Gosu::Image.new(window, "#{$preface}media/UI Frame.png", ZOrder::UIBackground)
    @last_a = nil
    @bgcolor = 0xff000000
  end
  
  def draw(game_level, window)
    
    @frame.draw(0,0,ZOrder::UIBackground)
    #@frame.draw_as_quad(0,0,@bgcolor, @ui_dim.x,0,@bgcolor, @ui_dim.x,@ui_dim.y,@bgcolor,0,@ui_dim.y,@bgcolor, ZOrder::UIBackground)
    @time_left = (game_level.time_to_next_action - Time.now).ceil
    if @time_left < 0
      @time_left = 0
    end
    t = @time_left
    @font.draw(t, 120, 80 - @font.height / 2.0, ZOrder::UIText, 1, 1, 0xffffffff)
    
    if t == 0
      @timer_images[0].draw(@timer_base.x, @timer_base.y, ZOrder::UI, @factor, @factor)
    elsif t < 4
      @timer_images[t].draw(@timer_base.x, @timer_base.y, ZOrder::UI, @factor, @factor)
    else
      @timer_images[3].draw(@timer_base.x, @timer_base.y, ZOrder::UI, @factor, @factor)
    end

    offset = 125
    space = 100
    pos_y = 20
    
    if @last_a != window.current_action and !window.current_action.nil?
      @last_a = window.current_action
      @timer = 60
    end
    @timer ||= 0
    @timer -= 1
      
    @actions.each_with_index do |act,i|
      a = act[0]
      pos_x = offset + i*space
      if @timer > 0 and i == @last_a
        ind = 1
      else
        ind = 0
      end
      case a
        when 'super_jump'
          @super_jump_arrow[ind].draw(pos_x, pos_y, ZOrder::UI)
        when 'move_right'
          @straight_arrow[ind].draw(pos_x, pos_y, ZOrder::UI)
        when 'move_left'
          @straight_arrow[ind].draw_rot(pos_x + @straight_arrow[ind].width/2.0, pos_y + @straight_arrow[ind].height/2.0, ZOrder::UI, 180)
        when 'jump'
          @straight_arrow[ind].draw_rot(pos_x + @straight_arrow[ind].width/2.0, pos_y + @straight_arrow[ind].height/2.0, ZOrder::UI, 90)
        when 'jump_left'
          @jump_left_arrow[ind].draw(pos_x, pos_y, ZOrder::UI)
        when 'jump_right'
          @jump_right_arrow[ind].draw(pos_x, pos_y, ZOrder::UI)
        when 'pause'
          #window.draw_quad(pos_x - 15, pos_y - 15, 0xff00ff00, pos_x + 15, pos_y - 15, 0xff00ff00, pos_x + 15, pos_y + 15, 0xff00ff00, pos_x - 15, pos_y + 15, 0xff00ff00, ZOrder::UI)
      end
    end
  end
  
end
