require 'spec_helper'

describe "Note Pages" do

  subject { page }

  let(:user) { Fabricate(:user) }

  before { sign_in user }

  describe "note creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "it should not create a note" do
      expect { click_button "Post" }.not_to change(Note, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('sorry') }
      end
    end
  end

  describe "note destruction" do
    before { Fabricate(:note, user: user) }

    describe "as the right user" do
      before { visit root_path }

      it "should delete a note" do
        expect { click_link "delete" }.to change(Note, :count).by(-1)
      end
    end
  end

end
