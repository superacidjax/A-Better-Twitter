class PagesController < ApplicationController

  def home
    @title = "A Better Twitter | Home"
  end

  def help
    @title = "A Better Twitter | Help"
  end

  def about
    @title = "A Better Twitter | About"
  end

  def contact
    @title = "A Better Twitter | Contact"
  end
end
