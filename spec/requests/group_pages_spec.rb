# require 'spec_helper'

# describe "Group pages" do

#   subject { page }

#   let(:user) { Fabricate(:user) }
#   before { sign_in user }

#   describe "group creation" do
#     before { visit new_group_path }

#     describe "with invalid information" do

#       it "should not create a group" do
#         expect { click_button "Create my group!" }.should_not change(Group, :count)
#       end

#       describe "error messages" do
#         before { click_button "Create my group!" }
#         it { should have_content('error') }
#       end
#     end

#     describe "with valid information" do

#       before do
#         fill_in 'Group Name',   with: "I Love Cats"
#         fill_in 'Description',  with: "This is a group all about cats."
#         fill_in 'Category',     with: "Pets"
#       end

#       it "should create a group" do
#         expect { click_button "Create my group" }.should change(Group, :count).by(1)
#       end
#     end
#   end
# end