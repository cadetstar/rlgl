class GameWindow < Gosu::Window
  attr_reader :win_tag
  def initialize
    super 800, 600, false
    self.caption = 'Red Light, Green Light'
     @icon = Gosu::Image.new(self, "#{$preface}media/wifi_4.ico")

    @levels = GameLevels.names
    @menu = Menu.new(@levels, self)
    @active_screen = 'menu'
    
    @death_font = Gosu::Font.new(self, "#{$preface}media/BLACKLTR.ttf", 128)
    @t = "You are DEAD!"
    @render_x = (self.width - @death_font.text_width(@t)) / 2.0
    @song = Gosu::Sample.new(self, "#{$preface}media/Silly Fun Theme #{rand > 0.5 ? 'A' : 'B'}.mp3")
    @death_song = Gosu::Sample.new(self, "#{$preface}media/Grammophone Taps.mp3")
    lets = %w(C D E)
    @win_tag = Gosu::Sample.new(self, "#{$preface}media/Silly Fun End #{lets[rand(lets.size)]}.mp3")
  end
  
  def update
    case @active_screen
      when 'game'
        unless @dead
          if @death_inst 
            @death_inst.stop
          end
          if @player.player_in_control
            if button_down? Gosu::KbRight
              @player.move_right
            end
            if button_down? Gosu::KbLeft
              @player.move_left
            end
          end
          @game_level.update(@player)
          if @active_screen == 'game'
            @player.update(@game_level)
          end
        end
    end
  end
  
  def current_action
    if @game_level.time_to_next_action < Time.now
      @player.current_action
    else
      nil
    end
  end
  
  def draw
    case @active_screen
      when 'menu'
        @menu.draw(self)
      when 'game'
        if @dead
          self.draw_quad(0,0,@dead,self.width,0,@dead,self.width,self.height,@dead_bot,0,self.height,@dead_bot,ZOrder::Dead)
          @death_font.draw(@t, @render_x, (self.height - @death_font.height)/2.0, ZOrder::DeadText)
          @counter -= 1
          if @counter <= 0
            self.regen_level
          end
        else
          @game_level.draw
          @ui.draw(@game_level, self)
          @player.draw(@game_level)
        end
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
            self.regen_level
          when Gosu::KbEscape
            close
          else
            return
        end
      when 'game'
        case id
          when Gosu::KbUp
            @player.jump if @player.player_in_control
          when Gosu::KbEscape
              return_to_menu
            return
        end
    end
    
    if id == Gosu::KbEscape
      close
    end
  end
  def return_to_menu
    @levels = GameLevels.names
    @menu = Menu.new(@levels, self)
    @game_level = nil
    @ui = nil
    @player = nil
    @active_screen = 'menu'
    if @song_inst
      @song_inst.stop
    end
    if @death_inst 
      @death_inst.stop
    end
  end
  
  def kill_player
    if @song_inst
      @song_inst.stop
    end
    
    @dead = 0xffff0000
    @dead_bot = 0x00ff0000
    @counter = 120
#    @death_inst = @death_song.play
  end
    
  def regen_level
    if @death_inst 
      @death_inst.stop
    end
    
    @dead = nil
    @game_level = ActiveGameLevel.new(@current_level, self)
    @ui = UI.new(@game_level.actions, self)
    @player = Player.new(self, @game_level, @current_level['start_pos'])
    @song_inst = @song.play(1,1,true)
  end
end
