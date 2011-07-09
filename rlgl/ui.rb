
class UI
  def initialize
    @timer_circle_x = 50
    @timer_circle_y = 50
    @circle_size = 30
  end
  
  def draw(game_level, window)
    @time_left = (game_level.time_to_next_action - Time.now).ceil
    arcdist = 360 / game_level.action_interval
    
    if @time_left > game_level.action_interval * 0.5
      color = 0xff00ff00
    elsif @time_left <= 2.0
      color = 0xffff0000
    else
      color = 0xffffff00
    end
    
    
    (0...@time_left).each do |i|
      window.draw_triangle(@timer_circle_x, @timer_circle_y, color, @timer_circle_x+Gosu::offset_x(arcdist*i, @circle_size), @timer_circle_y+Gosu::offset_y(arcdist*i,@circle_size), color, @timer_circle_x+Gosu::offset_x(arcdist*(i+1),@circle_size), @timer_circle_y + Gosu::offset_y(arcdist*(i+1),@circle_size),color, ZOrder::UI)
    end
  end
  
end
