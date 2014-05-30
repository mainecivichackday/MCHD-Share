require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/share.db")
#DataMapper.auto_upgrade!
#DataMapper.auto_migrate!

class PostToConfirm
  include DataMapper::Resource
  property :id, Serial
  property :share, String, :required => true
end

class Post
  include DataMapper::Resource
  property :id,	   Serial
  property :display, String, :required => true
end
DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  count = rand(1...Post.all.count + 1)
  @post = Post.get(count)
  @count = count
  erb :index
end

get '/share' do
  erb :share
end

post '/share' do
  PostToConfirm.create(:share => params[:toshare])
  redirect '/'
end
