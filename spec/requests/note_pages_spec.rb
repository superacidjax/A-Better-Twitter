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
end
