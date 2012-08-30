class MembershipsController < ApplicationController

expose(:user)

  def create
    # user = User.find(params[:membership][:group_id])
    # current_user.join!(group)
    # respond_to do |format|
    #   format.html { redirect_to user }
    #   format.js
    # end
  end

  def destroy
  end
end
