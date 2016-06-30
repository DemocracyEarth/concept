require 'securerandom'
require 'rest-client'
require 'json'

class UsersController < ActionController::Base

  # Set the request parameters
  host = 'http://jsonplaceholder.typicode.com'
  user = 'admin'
  pwd = 'admin'


  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to action: 'singin'
    else
      flash[:error] = "The email  exist or name can not blank"
      redirect_to '/'
    end

  end

  def singin
  end

  def login
    @user = User.find_by email:params['email']
    if @user && @user.authenticate(params['password'])
      session[:user_id] = @user.id
      redirect_to '/vote'
    else
      flash[:error] = "Fail Authenticated"
      redirect_to action: 'singin'
    end
  end

  def vote
    if !session[:user_id]
      redirect_to action: 'singin'
    end
  end

  def decition
    @user = User.find(session[:user_id])
    if @user.interation != true
      @user.interation = true
      @user.save
      endPointBlockChain(1)
      redirect_to '/confirm'
    else
      flash[:error] = "You have Already Voted"
      redirect_to '/vote'
    end

  end

  def confirmVote
  end

  def endPointBlockChain(decition)
    response = RestClient.get("http://jsonplaceholder.typicode.com/posts/1",
                               #request_body_map.to_json,    # Encode the entire body as JSON
                               { #:content_type => 'application/json',
                                :accept => 'application/json'})
    puts "#{response.to_str}"
    puts "Response status: #{response.code}"

  rescue => e
    puts "ERROR: #{e}"
  end


  private
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
