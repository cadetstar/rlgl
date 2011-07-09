class GameLevels
  attr_accessor :actions
  attr_accessor :action_interval
  attr_accessor :entities

  def self.names
    f = File.open('./levels/level_names.txt')
    JSON.parse(f.readlines.first)
  end
    
  def initialize
    Dir.glob('./levels/*')
  end
  
end
