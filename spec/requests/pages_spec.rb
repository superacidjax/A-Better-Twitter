require 'spec_helper'

describe "Pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
      it { should have_selector('h3', text: 'People you follow') }
      it { should have_selector('h3', text: 'In your groups') }
      it { should have_selector('title', text: full_title('')) }
      it { should_not have_selector('title', text: '| Home') }

      describe "for signed-in users" do
        let(:user) { Fabricate(:user) }

        before do
          Fabricate(:note, user: user, content: "Lorum ipsum")
          Fabricate(:note, user: user, content: "Brian is great")
          Fabricate(:group, user: user, name: "BBB")
          Fabricate(:group, user: user, name: "ABB")
          sign_in user
          visit root_path
        end
        it "should render the user's feed" do
          user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end

        it "should show the user's groups" do
          page.should have_content("ABB")
          page.should have_content("BBB")
        end


        describe "follower/following counts" do
          let(:other_user) { Fabricate(:user) }
          before do
            other_user.follow!(user)
            visit root_path
          end

          it { should have_link("following", href: following_user_path(user)) }
          it { should have_link("1 follower", href: followers_user_path(user)) }
        end

        describe "create group link" do
          it { should have_link('Create a group'), href: new_group_path }
        end

        describe "view groups a user manages"
          let(:user) { Fabricate(:user) }
          let(:group) { Fabricate(:group, user: user) }
          before do
            sign_in user
            group.save
            visit root_path
          end

          it { should have_link(group.name, href: group_path(group)) }
        end

        describe "view groups of which a user is a member"
          let(:user) { Fabricate(:user) }
          let(:other_user) { Fabricate(:user) }
          let(:group) { Fabricate(:group, user: other_user) }
          before do
            sign_in user
            user.join!(group)
            visit root_path
          end

          it { should have_link(group.name, href: group_path(group)) }
        end

  describe "Help page" do
    before { visit help_path}
      it { should have_selector('h1', text: 'Help') }
      it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path}
      it { should have_selector('h1', text: 'About') }
      it { should have_selector('title', text: 'About') }
  end

  describe "Contact page" do
    before { visit contact_path}
      it { should have_selector('h1', text: 'Contact') }
      it { should have_selector('title', text: 'Contact') }
  end

  # it "should have the right links on the layout" do
  #   visit root_path
  #   click_link "sign in"
  #   page.should have_selector 'title', text: full_title('sign in')
  #   # click_link "About"
  #   # page.should have_selector 'title', text: full_title('About')
  #   click_link "help"
  #   page.should have_selector 'title', text: full_title('help')
  #   # click_link "Contact"
  #   # page.should have_selector 'title', text: full_title('Contact')
  #   click_link "Home"
  #   click_link "Sign up now!"
  #   page.should have_selector 'title', text: full_title('Sign up')
  # end
end
