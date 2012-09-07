class NotesController < ApplicationController
  before_filter :signed_in_user
  before_filter :the_right_user,  only: :destroy

expose(:note)

  def create
    note = current_user.notes.build(params[:note])
    if note.save
      flash[:success] = "Note created!"
      redirect_to root_path
    else
      if note.errors.any?
        flash[:failure] = "I'm sorry! #{note.errors.full_messages}"
        #@feed_items = current_user.feed.paginate(page: params[:page])
        @feed_items = []
        @group_feed_items = []
      end
      render 'pages/home'
    end
  end

  def destroy
    note.destroy
    redirect_to root_path
  end

  private

    def the_right_user
      note = current_user.notes.find_by_id(params[:id])
      redirect_to root_path if note.nil?
    end

end