class GameWindow < Gosu::Window
  def initialize
    super 800, 600, false
    self.caption = 'Red Light, Green Light'
    
    @levels = GameLevels.names
    
    @menu = Menu.new(@levels, self)
    @active_screen = 'menu'
  end
  
  def update
    case @active_screen
      when 'game'
        @game_level.update
    end
  end
  
  def draw
    case @active_screen
      when 'menu'
        @menu.draw(self)
      when 'game'
        @game_level.draw
        @ui.draw(@game_level, self)
    end
  end
  
  def button_down(id)
    case @active_screen
      when 'menu'
        case id
          when Gosu::KbUp
            @menu.up_menu
          when Gosu::KbDown
            @menu.down_menu
          when Gosu::KbEnter, Gosu::KbReturn
            @current_level = @menu.select_entry
            @active_screen = 'game'
            @game_level = ActiveGameLevel.new(@current_level, self)
            @ui = UI.new
          when Gosu::KbEscape
            close
          else
            return
        end
        #@menu.draw(self)
    end
    
    if id == Gosu::KbEscape
      close
    end
  end
end
