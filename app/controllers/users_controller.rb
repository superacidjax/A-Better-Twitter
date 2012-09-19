class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy,
                :following, :followers]
  before_filter :the_right_user,  only: [:edit, :update]
  before_filter :admin_user,      only: :destroy

  expose(:user)

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    # @notes = user.notes.paginate(page: params[:page])
  end

  def create
    if user.save
      sign_in user
      flash[:success] = "Welcome to MamaBirds!"
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if user.update_attributes(params[:user])
      sign_in user
      flash[:success] = "Profile updated"
      redirect_to user
    else
    render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed!"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @users = user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def the_right_user
      redirect_to root_path unless current_user?(user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
