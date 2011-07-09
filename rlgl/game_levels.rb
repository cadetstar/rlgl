class GameLevels
  def self.names
    f = File.open('./levels/level_names.txt')
    JSON.parse(f.readlines.first)
  end
    
  def initialize
    Dir.glob('./levels/*')
  end
  
end
