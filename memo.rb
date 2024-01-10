require 'cgi'
require 'sinatra'
require 'sinatra/reloader'

FILE_PATH = 'public/memos.json'.freeze
FILE_PATH.freeze

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = get_memos(FILE_PATH)
  erb :memos
end

get '/memos/:id/editings' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :editings
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  memos = get_memos(FILE_PATH)
  memos[params[:id]] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos = get_memos(FILE_PATH)
  memos.delete(params[:id])
  set_memos(FILE_PATH, memos)
  redirect '/memos'
end

def set_memos(file_path, memos)
  File.open(file_path, 'w') { |f| JSON.dump(memos, f) }
end

get '/memos/newies' do
  erb :newies
end

get '/memos/:id' do
  memos = get_memos(FILE_PATH)
  @title = memos[params[:id]]['title']
  @content = memos[params[:id]]['content']
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  memos = get_memos(FILE_PATH)
  max_number = memos.keys.map(&:to_i).max || 0
  id = (max_number + 1).to_s
  memos[id] = { 'title' => title, 'content' => content }
  set_memos(FILE_PATH, memos)
  redirect '/memos'
end
