$LOAD_PATH << './rlgl' 

require 'action_view'
require 'action_view/base'
require 'action_view/helpers'
include ActionView::Helpers
require 'sinatra'
require 'erb'
require 'main'


set :server, %w(thin webrick)
set :port, 8000
set :views, File.dirname(__FILE__) + '/editor'

get '/' do
  redirect '/levels'
end

get '/levels' do
  @levels = GameLevels.names.collect{|l| l['name']}
  erb :index
end

get '/level/edit/:name' do
  unless level = GameLevels.names.select{|l| l['name'] == params[:name]}.first
    'Nothing there.<br /><a href="/">Back</a>'
  else
    filename = "./levels/#{level['file']}"
    unless File.exists?(filename)
      a = File.new(filename, 'w')
      a.puts {}.to_json
      a.close
    end
    
    f = File.open(filename)
    begin
      @info = JSON.parse(f.readlines.first)
    rescue
      @info = {}
    end
    @name = level['name']
    puts @info.inspect
    @action_list = %w(move_left move_right jump jump_right jump_left pause)
    
    erb :edit
  end
end

post '/level/save/:name' do
  if level = GameLevels.names.select{|l| l['name'] == params[:name]}.first
    name = params[:name]
    if params[:mod_name] != params[:name]
      name = params[:mod_name]
      f = File.open('./levels/level_names.txt', 'r')
      names = JSON.parse(f.readlines.first)
      f.close
      
      new_names = names.collect{|l| {'name' => (l['name'] == params[:name] ? params[:mod_name] : l['name']), 'file' => l['file']}}
      a = File.open('./levels/level_names.txt','w')
      a.puts new_names.to_json
      a.close
    end
    if level = GameLevels.names.select{|l| l['name'] == name}.first
      c = {}
      c['action_interval'] = params[:interval]
      c['start_pos'] = {}
      c['start_pos']['x'] = params[:pos_x]
      c['start_pos']['y'] = params[:pos_y]
      c['width'] = params[:width]
      
      c['actions'] = params[:actions].collect{|c| puts c.inspect;[c['action'],c['delay']]}
      c['entities'] = {}
      c['entities']['goal'] = params[:goal]
      c['entities']['platforms'] = params[:platforms]
      c['entities']['damagers'] = params[:damagers]
      c['entities']['props'] = params[:props]
      
      puts params.inspect
      
      filename = "./levels/#{level['file']}"
      f = File.open(filename, 'w')
      f.puts c.to_json
      f.close
      
    end
  end
  
  redirect '/'
end

post '/level/new' do
  @name = params[:name]
  new_num = GameLevels.names.collect{|l| l['file'].gsub('.txt.','').to_i}.max.to_i + 1
  filename = sprintf('%03u',new_num) + '.txt'
  f = File.new("./levels/#{filename}",'w+')
  f.puts {}.to_json
  f.close
  
  f = File.open('./levels/level_names.txt','r')
  names = JSON.parse(f.readlines.first)
  
  names << {'name' => @name, 'file' => filename}
  f.close
  
  a = File.open('./levels/level_names.txt','w')
  a.puts names.to_json
  a.close
  
  redirect "/level/edit/#{@name.gsub(' ', '%20')}"
end

get '/level/:direction/:name' do
  levels = GameLevels.names
  adj = (params[:direction] == 'down' ? 1.01 : -1.01)
  if level = levels.select{|l| l['name'] == params[:name]}.first
    new_levels = []
    levels.collect{|l| if l['name'] == params[:name] then l['order'] = (l['order'].to_f + adj) end;l}.sort_by{|j| [j['order'].to_f,j['name']]}.each_with_index do |a,i|
      new_levels << a.merge({'order' => (i+1)})
    end
    
    a = File.open('./levels/level_names.txt','w')
    a.puts new_levels.to_json
    a.close
    
  end
  redirect '/'
end

 