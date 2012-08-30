class GroupsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]

  expose(:group)

  def create
    group = current_user.groups.build(params[:group])
    if group.save
      flash[:success] = "Group created!"
      redirect_to root_path
    else
      if group.errors.any?
        flash[:failure] = "I'm sorry! #{group.errors.full_messages}"
      end
      render 'groups/new'
    end
  end

  def destroy
  end

end
