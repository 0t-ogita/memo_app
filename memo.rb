require 'cgi'
require 'pg' 
require 'sinatra'
require 'sinatra/reloader'

def get_memos(file_path)
  File.open(file_path) { |f| JSON.parse(f.read) }
end

def conn
  @conn ||= PG.connect( dbname: 'postgres', user: 'postgres', password: 'ogiogi' )
end

def read_memo(id)
  result = conn.exec_params('SELECT * FROM memos WHERE id = $1;', [id])
  result.tuple_values(0)
end

def post_memo(title, content)
  conn.exec_params('INSERT INTO memos(title, content) VALUES ($1, $2);', [title, content])
end

def edit_memo(title, content, id)
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3;', [title, content, id])
end

def delete_memo(id)
  conn.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end

def read_memos
  conn.exec('SELECT * FROM memos')
end

configure do
  result = conn.exec("SELECT * FROM information_schema.tables WHERE table_name = 'memos'")
  conn.exec('CREATE TABLE memos (id serial, title varchar(255), content text)') if result.values.empty?
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = read_memos
  erb :memos
end

get '/memos/:id/editings' do
  memo = read_memo(params[:id])
  @title = memo[1]
  @content = memo[2]
  erb :editings
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  edit_memo(title, content, params[:id])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect '/memos'
end

get '/memos/newies' do
  erb :newies
end

get '/memos/:id' do
  memo = read_memo(params[:id])
  @title = memo[1]
  @content = memo[2]
  erb :show
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  post_memo(title, content)
  redirect '/memos'
end
