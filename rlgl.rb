if ENV["OCRA_EXECUTABLE"]
  $preface = "#{File.dirname($0)}/"
else
  $preface = './'
end
#puts Dir.glob("#{$preface}*")

$LOAD_PATH.unshift File.join(File.dirname($0), '/rlgl')

require 'main'

if not defined?(Ocra)
  $w = GameWindow.new
  $w.show
end