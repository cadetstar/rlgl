class Menu
  def initialize(levels, window)
    @selected_level = 0
    @levels = levels
    
    @reg_font = Gosu::Font.new(window, Gosu::default_font_name, 20)
    @sel_font = Gosu::Font.new(window, Gosu::default_font_name, 26)
  end
  
  def draw(window)
    @levels.each_with_index do |l, i|
      if i == @selected_level
        font = @sel_font
        color = 0xffffff00
      else
        font = @reg_font
        color = 0xffffffff
      end
      
      t = l['name']
      font.draw(t, ((window.width - font.text_width(t))/2.0), (i+1)*50, ZOrder::Menu, 1.0, 1.0, color)
    end
  end
  
  def up_menu
    unless @selected_level == 0
      @selected_level -= 1
    end
  end
  
  def down_menu
    unless @selected_level == (@levels.size - 1)
      @selected_level += 1
    end
  end
  
  def select_entry
    f = File.open("./levels/#{@levels[@selected_level]['file']}")
    JSON.parse(f.readlines.first.to_s)
  end
  
end
