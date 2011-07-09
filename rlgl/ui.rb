
class UI
  def initialize(actions, window)
    @timer_circle_x = 50
    @timer_circle_y = 50
    @circle_size = 30
    @actions = actions.collect{|a| %w(jump jump_right jump_left move_right move_left).include?(a[0]) ? a[0] : nil}.compact
    @font = Gosu::Font.new(window, Gosu::default_font_name, 16)
  end
  
  def draw(game_level, window)
    @time_left = (game_level.time_to_next_action - Time.now).ceil
    if @time_left > 0
      arcdist = 360 / game_level.action_interval
      
      if @time_left > game_level.action_interval * 0.5
        color = 0xff00ff00
      elsif @time_left <= 2.0
        color = 0xffff0000
      else
        color = 0xffffff00
      end
      offset = 0
    else
      arcdist = (360 / 8.0)
      color = 0xffff0000
      @time_left = 8
      offset = 22.5
      t = 'STOP'
      @font.draw(t, @timer_circle_x-@font.text_width(t)/2.0, @timer_circle_y - @font.height / 2.0, ZOrder::UIText)
    end
    
    (0...@time_left).each do |i|
      window.draw_triangle(@timer_circle_x, @timer_circle_y, color, @timer_circle_x+Gosu::offset_x(arcdist*i+offset, @circle_size), @timer_circle_y+Gosu::offset_y(arcdist*i+offset,@circle_size), color, @timer_circle_x+Gosu::offset_x(arcdist*(i+1)+offset,@circle_size), @timer_circle_y + Gosu::offset_y(arcdist*(i+1)+offset,@circle_size),color, ZOrder::UI)
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
