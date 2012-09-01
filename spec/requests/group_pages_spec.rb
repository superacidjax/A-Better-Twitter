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
        fill_in 'Group Name',   with: "I Love Cats"
        fill_in 'Description',  with: "This is a group all about cats."
        select  'politics',     from: "Category"
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
end