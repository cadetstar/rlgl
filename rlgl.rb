$LOAD_PATH << './rlgl' 

require 'gosu'
require 'json'
require 'chipmunk'

require 'window'
require 'player'
require 'active_game_level'
require 'game_levels'
require 'constant_modules'
require 'menu'

$w = GameWindow.new
$w.show