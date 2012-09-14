require 'spec_helper'

describe "Group pages" do

  subject { page }

  let(:user) { Fabricate(:user) }
  before { sign_in user }

  describe "group creation" do
    before do
      sign_in user
      visit new_group_path
    end

    describe "with invalid information" do

      describe "error messages" do
        before { click_button "Create my group!" }
        it { should have_content("I'm sorry") }
      end
    end

    describe "with valid information" do

      before do
        fill_in 'group_name',   with: "I Love Cats"
        fill_in 'group_description',  with: "This is a group all about cats."
        select  'politics',     from: "group_category"
      end

      it "should create a group" do
        expect {click_button "Create my group" }.to change(Group, :count).by(1)
      end
    end
  end

  describe "group deletion" do
    let(:group) { Fabricate(:group, user_id: 3) }
    let(:user) { Fabricate(:user, id: 3) }
    before do
      sign_in group.user
      visit group_path(group)
    end

    it "should delete the group" do
      expect { click_button "Delete my group" }.to change(Group, :count).by(-1)
    end
  end

  describe "index" do

    let(:user) { Fabricate(:user) }

    before(:all) do
      Group.delete_all
      if Group.all.empty?
        35.times { Fabricate(:group) }
      else
      end
    end

    after(:all) { Group.delete_all }

    before(:each) do
      sign_in user
      visit groups_path
    end

    it { should have_selector('title', text: 'all groups') }
    it { should have_selector('h1', text: 'all groups') }

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each group" do
        Group.paginate(page: 1).each do |group|
          page.should have_selector('li>a', text: group.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete'), href: '#' }

      describe "as an admin user" do
        let(:admin) { Fabricate(:admin, id: 757) }
        before do
          sign_in admin
          visit groups_path
        end

        it { should have_link('delete', href:  group_path(Group.first)) }
      end
    end
  end
end