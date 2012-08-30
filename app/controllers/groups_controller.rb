class GroupsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]

  expose(:group)

  def create
  end

  def destroy
  end

end
