class PagesController < ApplicationController

expose(:note)

  def home
    if signed_in?
      note = current_user.notes.build
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
