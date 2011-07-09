$LOAD_PATH << './rlgl' 

require 'gosu'
require 'json'
require 'chipmunk'

require 'entity'
require 'platform'
require 'window'
require 'player'
require 'active_game_level'
require 'game_levels'
require 'constant_modules'
require 'menu'
require 'ui'

$w = GameWindow.new
$w.show