class GameLevels
  attr_accessor :actions
  attr_accessor :action_interval
  attr_accessor :entities

  def self.names
    f = File.open('./levels/level_names.txt')
    begin
      levels = JSON.parse(f.readlines.first)
      levels = levels.sort_by{|c| [c['order'].to_i, c['name']]}
    rescue
      levels = []
    end
    levels
  end
    
  def initialize
  end
  
end
