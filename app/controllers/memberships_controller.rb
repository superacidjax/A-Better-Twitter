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
end
