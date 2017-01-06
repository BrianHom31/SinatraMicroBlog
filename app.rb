require 'sinatra'
require 'sinatra/activerecord'
require 'sqlite3'
require './models'

enable :sessions
set :sessions => true
set :database, 'sqlite3:blog.sqlite3'

get '/' do
	if session[:user_id]
		@user = User.find(session[:user_id]) if @user
	end
	erb :home
end

get '/signup' do
	erb :signup
end

post '/signup' do
	@user = User.create(username: params[:username], password: params[:password], email: params[:email])
	session[:user_id] = @user.id
	redirect '/post'
end

get '/signin' do
	erb :signin
end

post '/signin' do
	@user = User.find_by(username: params[:username], password: params[:password])
		if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		redirect '/post'
	else
		redirect '/signup'
	end
end

get "/signout" do
@session = session
@session.destroy
  redirect '/'
end

get '/user/:id' do
  @view_user = User.find(params[:id])
  @view_post = Post.find(params[:id])
  @user = User.find(session[:user_id])
  erb :user
end

get '/after_post/:id' do
	@user = User.find(session[:user_id])
  @post = Post.find(params[:id])
  erb :after_post
end

get '/newpost' do
	@user = User.find(session[:user_id])
	erb :newpost
end

post '/newpost' do
	@user = User.find(session[:user_id])
	post = Post.create(user_id: session[:user_id], title: params[:title], content: params[:message])
	redirect "/after_post/#{post.id}"
end

post '/after_post' do
	comment = Comment.create(post_id: params[:post_id], user_id: session[:user_id], content: params[:message])
	redirect "/after_post/#{comment.post.id}"
end

get '/post' do
  @posts = Post.all
  @user = User.find(session[:user_id])
  erb :post
end

get '/edit_acc' do
	@user = User.find(session[:user_id])
	erb :edit_acc
end

post '/update' do
	@user = User.find(session[:user_id])
	@user = @user.update(username: params[:username], password: params[:password], email: params[:email])
	redirect '/edit_acc'
end

get "/delete_account" do
  @user = User.find(session[:user_id])
  User.find(@user).destroy
  redirect '/'
end
