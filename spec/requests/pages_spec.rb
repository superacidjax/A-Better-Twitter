require 'spec_helper'

describe "Pages" do

  describe "Home page" do

  	it "should have the h1 'A Better Twitter'" do

      visit '/pages/home'
      page.should have_selector('h1', :text => 'A Better Twitter')
  	end

    it "should have the base title" do
      visit '/pages/home'
      page.should have_selector('title', :text => "A Better Twitter")
    end

    it "should not have a custom page title" do
      visit '/pages/home'
      page.should_not have_selector('title', :text => "A Better Twitter | Home")
    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do

      visit '/pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the right title" do
      visit '/pages/help'
      page.should have_selector('title', :text => "A Better Twitter | Help")
    end
  end

  describe "About page" do

    it "should have the h1 'About Us'" do

      visit '/pages/about'
      page.should have_selector('h1', :text =>'About Us')
    end

    it "should have the right title" do
      visit '/pages/about'
      page.should have_selector('title', :text => "A Better Twitter | About")
    end
  end

  describe "Contact page" do

    it "should have the h1 'Contact'" do

      visit '/pages/contact'
      page.should have_selector('h1', :text => 'Contact')
    end

    it "should have the right title" do
      visit '/pages/contact'
      page.should have_selector('title', :text => "A Better Twitter | Contact")
    end
  end
end
