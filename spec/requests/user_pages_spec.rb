require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "index" do

    let(:user) { Fabricate(:user) }

    before(:all) { 35.times { Fabricate(:user) } }
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1', text: 'All users') }

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li>a', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('Delete'), href: '#' }

      describe "as an admin user" do
        let(:admin) { Fabricate(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href:  user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end


  describe "Sign up page" do

    before { visit signup_path }
      it { should have_selector('h2', text: 'where groups come together') }
      it { should have_selector('title',
          text: full_title('where groups come together')) }
  end

  describe "public group page" do
    let(:user) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    let!(:group) { Fabricate(:group, user_id: user2.id) }

    before do
      visit group_path(group)
    end

    it { should have_selector('h1', text: group.name) }
    it { should have_link('Sign up now!', href: signup_path) }
  end

  describe "joining a group" do
    let(:user) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    let!(:group) { Fabricate(:group, user_id: user2.id) }

    before do
      sign_in user
      visit group_path(group)
    end

    it { should have_selector('h1', text: group.name) }
    it { should have_button('Join this group') }
  end

  describe "leaving a group" do
    let(:user) { Fabricate(:user) }
    let(:user2) { Fabricate(:user) }
    let!(:group) { Fabricate(:group, user_id: user2.id) }

    before do
      sign_in user
      user.join!(group)
      visit group_path(group)
    end

    it { should have_selector('h1', text: group.name) }
    it { should have_button('Leave this group') }
  end

  describe "profile page" do
    let!(:user) { Fabricate(:user) }
    let!(:user2) { Fabricate(:user, id: 732) }
    let!(:note1) { Fabricate(:note, user: user, content: "Hi!") }
    let!(:note2) { Fabricate(:note, user: user, content: "Bye") }
    let!(:group1) { Fabricate(:group, user: user, name: "BBB Group") }
    let!(:group2) { Fabricate(:group, user: user, name: "AAA Group") }


    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "notes" do
      it { should have_content(note1.content) }
      it { should have_content(note2.content) }
      #it { should have_content(note1.group.name) }
      it { should have_content(user.notes.count) }
    end

    describe "groups user owns" do
      it { should have_selector('li', text: group1.name) }
      it { should have_selector('li', text: group2.name) }
    end

    describe "join/leave buttons" do
      let(:group) { Fabricate(:group, user_id: 2) }
      before { sign_in user }

      describe "clicking join button" do
        before { visit group_path(group) }

        it "should increment the user group membership count" do
          expect do
            click_button('Join this group')
          end.to change(user.memberships, :count).by(1)
        end
      end

      describe "clicking leave button" do
        before do
          user.join!(group)
          visit group_path(group)
        end

        it "should deincrement the user group membership count" do
          expect do
            click_button('Leave this group')
          end.to change(user.memberships, :count).by(-1)
        end
      end

    end

    describe "follow/unfollow buttons" do
      let(:other_user) { Fabricate(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button('Follow')
            end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_selector('input', value: 'Unfollow') }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should deincrement the followed user count" do
          expect do
            click_button('Unfollow')
            end.to change(user.followed_users, :count).by(-1)
        end

        it "should deincrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_selector('input', value: 'Follow') }
        end
      end
    end
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

        describe "after submission" do
          before { click_button submit}
        it { should have_content('error') }
        it {should_not have_content('Password digest') }
        end
      end

      describe "with valid information" do

        before do
          fill_in "user_name",     with: "superacidjax"
          fill_in "first name",   with: "Brian"
          fill_in "last name",    with: "Dear"
          fill_in "email",        with: "brian@example.com"
          fill_in "password",     with: "password"
          fill_in "password confirmation", with: "password"
        end

        it "should create a user" do
          expect {click_button submit }.to change(User, :count).by(1)
        end

        describe "after saving a user" do

          before { click_button submit }

          let(:user) { User.find_by_email("brian@example.com") }

          it { should have_content(user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('sign out') }
        end
      end
  end

  describe "edit" do
    let(:user) { Fabricate(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do

      it { should have_selector('h1', text: 'Update your profile') }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "username",         with: new_name
        fill_in "email",            with: new_email
        fill_in "password",         with: user.password
        fill_in "password confirmation", with: user.password
        click_button "save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_link('sign out', href: signout_path) }
      it { should have_selector('div.alert.alert-success') }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "following/followers" do
    let(:user) { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }
    before { user.follow!(other_user) }


    describe "followed users (following)" do
      before do
        sign_in user
        visit following_user_path(user)
      end
      it { should have_selector('title', text: full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followed users (followers)" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      it { should have_selector('title', text: full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
