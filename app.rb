require 'sinatra'
require 'sinatra/activerecord'
require './models'

enable :sessions
set :sessions => true

# For Heroku
configure(:development) do
	set :database, 'sqlite3:blog.sqlite3'
end

########### ROUTES #############
get '/' do
	if session[:user_id]
		@user = User.find(session[:user_id]) if @user
	end
	erb :home
end

##################################
get '/signup' do
	erb :signup
end

##################################
post '/signup' do
	puts params.inspect
	@user = User.create(
		username: params[:username],
		password: params[:password],
		email: params[:email],
		fname: params[:fname],
		lname: params[:lname],
		user_location: params[:user_location],
		fav_genre: params[:fav_genre],
		fav_artist1: params[:fav_artist1],
		fav_artist2: params[:fav_artist2],
		fav_artist3: params[:fav_artist3]
		)
	session[:user_id] = @user.id
	redirect '/post'
end

##################################
get '/signin' do
	erb :signin
end

post '/signin' do
	@user = User.find_by(
	username: params[:username],
	password: params[:password])
		if @user && @user.password == params[:password]
			session[:user_id] = @user.id
			redirect '/post'
		else
		redirect '/signup'
	end
end

##################################
get "/signout" do
@session = session
@session.destroy
  redirect '/'
end

##################################
get '/user/:id' do

	@user = User.find(params[:id])
	puts "THIS IS THE USER:", @user.inspect

	@all_posts_by_user = @user.posts
	puts "ALL POSTS BY THIS USER:", @all_posts_by_user.inspect


  # @view_user = User.find(params[:id])
  # @view_post = Post.where(:user_id => params[:id])
	#
	# # find all posts where user_id = id
	#
  # @user = User.find(session[:user_id])
	# @post = Post.all
  erb :user
end

##################################
get '/after_post/:id' do
	@user = User.find(session[:user_id])
  @post = Post.find(params[:id])
  erb :after_post
end

##################################
get '/newpost' do
	@user = User.find(session[:user_id])
	erb :newpost
end

########
post '/newpost' do
	puts params.inspect
	@user = User.find(session[:user_id])
	@post = Post.create(
	user_id: session[:user_id],
	title: params[:title],
	content: params[:message],
	artist: params[:artist],
	location: params[:location])

	params[:post_id] = @post.id

	redirect "/after_post/#{@post.id}"
end

##################################
post '/after_post' do
	comment = Comment.create(
	post_id: params[:post_id],
	user_id: session[:user_id],
	content: params[:message],
	artist: params[:artist],
	location: params[:location])
	redirect "/after_post/#{comment.post.id}"
end

##################################
get '/post' do
  @posts = Post.all
  @user = User.find(session[:user_id])
  erb :post
end

##################################
get '/edit_post/:id' do
	@user = User.find(session[:user_id])
	# @post = Post.find(params[:id])
	@post = Post.find_by_id(params["id"])
	erb :edit_post
end

##################################
post '/update_post/:post_id' do
	@user = User.find(session[:user_id])
	@post = Post.find(params[:post_id])

	if params[:content] != ""
		@post.update(content: params[:content])
	end

	if params[:title] != ""
		@post.update(title: params[:title])
	end

	if params[:artist] != ""
		@post.update(artist: params[:artist])
	end

	if params[:location] != ""
		@post.update(location: params[:location])
	end
	# @post = Post.create(
	# user_id: session[:user_id],
	# title: params[:title],
	# content: params[:message],
	# artist: params[:artist],
	# location: params[:location])
	# @update_post = Post.update(
	# user_id: session[:user_id],
	# title: params[:title],
	# content: params[:message],
	# artist: params[:artist],
	# location: params[:location])

	puts params

	# params.each do |key, value|
	#   puts "THIS IS THE KEY:", key
	#   puts "THIS IS THE VAL:", value
	#
	# 	# if value does not eq empty string
	# 		# update that key with the new val
	# 	# else
	# 		# do nothing
	#
	# 	if params
	# 		@post.update(key: params[:value])
	# 	end
	# end


	# params.keys.each do |x|
	# 	if (params[x] != "")
	# 		@post.update(x => params[x])
	# 	end
	# end

	redirect '/post'
end

##################################
get '/edit_acc' do
	@user = User.find(session[:user_id])
	erb :edit_acc
end

##################################
post '/update' do

	params.each do |x|
		puts "Each x in params: ",x
	end

	@user = User.find(session[:user_id])
	puts params.inspect

	#loops over the keys of each parameter, where x is the key. if the parameter of the key is NOT an empty string, update the value of the key. The empty fields are not updated as empty strings. Thanks, Fizel :)  (and Dan...and Liza...)
	params.keys.each do |x|
		if (params[x] != "")
			puts x, params[x]
			@user.update(x => params[x])
		end
	end

	#The long, incorrect way.
	# @user = @user.update(
	# username: params[:username],
	# password: params[:password],
	# email: params[:email],
	# fname: params[:fname],
	# lname: params[:lname],
	# user_location: params[:user_location],
	# fav_genre: params[:fav_genre],
	# fav_artist1: params[:fav_artist1],
	# fav_artist2: params[:fav_artist2],
	# fav_artist3: params[:fav_artist3]
	# )

	redirect '/edit_acc'

end

##################################
get "/delete_account" do
  @user = User.find(session[:user_id])
  User.find(@user).destroy

	# User.destroy(session[:user_id])
  redirect '/'
end

##################################
get '/delete_post/:id' do
	# puts params
	@post = Post.find_by_id(params["id"])
	# puts "delete route", @post
	# @post = Post.find(session[:user_id])

	Post.find(@post).destroy
	redirect '/post'
end
