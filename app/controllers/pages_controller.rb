class PagesController < ApplicationController

expose(:note)
expose(:group)

  def home
    if signed_in?
      note = current_user.notes.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @group_feed_items = current_user.group_feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
