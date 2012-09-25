class MembershipsController < ApplicationController
  before_filter :signed_in_user

  expose(:user)
  expose(:group)
  respond_to :html, :js

  def create
    group = Group.find(params[:membership][:group_membership_id])
    current_user.join!(group)
    respond_with group
  end

  def destroy
    group = Membership.find(params[:id]).group_membership
    current_user.leave!(group)
    respond_with group
  end

  def update
    group = Membership.find(params[:id]).group_membership
    user = Membership.find(params[:id])
    if user.role == 'user'
      user.make_mod
      flash[:success] = "is now a moderator!"
    elsif user.role == 'moderator'
      user.kill_mod
      flash[:success] = "#{user.name} is now NOT a moderator!"
    else
      redirect_to root_path
    end
    respond_with group
  end
end
