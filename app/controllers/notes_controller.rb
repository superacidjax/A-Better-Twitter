class NotesController < ApplicationController
  before_filter :signed_in_user

expose(:note)

  def create
    note = current_user.notes.build(params[:note])
    if note.save
      flash[:success] = "Note created!"
      redirect_to root_path
    else
      if note.errors.any?
        flash[:failure] = "I'm sorry! #{note.errors.full_messages}"
      end
      render 'pages/home'
    end
  end

  def destroy
  end

end