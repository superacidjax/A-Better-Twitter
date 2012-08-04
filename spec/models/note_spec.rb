require 'spec_helper'

describe Note do

  let(:user) { Fabricate(:user) }

  before do
    @note = user.notes.build(content: "Lorem ipsum")
  end

  subject { @note }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when a user id is not present" do
    before { @note.user_id = nil }
    it {should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Note.new(user_id: "1")
      should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe "with no content" do
    before { @note.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @note.content = "z" * 201 }
    it { should_not be_valid }
  end
end
