require 'securerandom'
require 'rest-client'
require 'json'

class UsersController < ActionController::Base

  # Set the request parameters
  @host = 'http://192.168.202.26:8008/'


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
      endPointBlockChain(params[:id])
      redirect_to '/confirm'
    else
      flash[:error] = "You have Already Voted"
      redirect_to '/vote'
    end

  end

  def confirmVote
  end

  def endPointBlockChain(decition)
    @vote = ""
    if decition == "1"
      puts "1"
      @vote = "yes"
    else
      puts "3"
      @vote = "no"
    end
    request_body_map = {
      :voters_id => session[:user_id],
      :proposal => @vote
    }
    puts vote
    response = RestClient.post("http://192.168.202.26:8008/send-vote",
                               request_body_map.to_json,    # Encode the entire body as JSON
                               { :content_type => 'application/json',
                                :accept => 'application/json'})
    puts "#{response.to_str}"
    puts "Response status: #{response.code}"

  rescue => e
    puts "ERROR: #{e}"
  end

  def logout
    session[:user_id] = ""
    redirect_to "/singin"
  end

  private
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
