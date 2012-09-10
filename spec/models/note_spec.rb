require 'spec_helper'

describe Note do

  let(:user) { Fabricate(:user) }

  before do
    @note = user.notes.build(content: "Lorem ipsum")
  end

  subject { @note }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:group_id) }
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
    before { @note.content = "z" * 256 }
    it { should_not be_valid }
  end

  describe "with no group" do
    before do
      @note.content = "zzz"
      @note.group_id = nil
    end
    it { should_not be_valid }
  end

  describe "with a group" do
    before do
      @note.content = "zzz"
      @note.group_id = 99
    end
    it { should be_valid }
  end

  describe "from_users_followed_by" do

    let(:user)       { Fabricate(:user) }
    let(:other_user) { Fabricate(:user) }
    let(:third_user) { Fabricate(:user) }

    before { user.follow!(other_user) }

    let(:own_post)        {       user.notes.create!(content: "foo") }
    let(:followed_post)   { other_user.notes.create!(content: "bar") }
    let(:unfollowed_post) { third_user.notes.create!(content: "baz") }
    subject { Note.from_users_followed_by(user) }

    it { should include(own_post) }
    it { should include(followed_post) }
    it { should_not include(unfollowed_post) }
  end

  # describe "from_groups_followed_by" do
  #   let(:user)        { Fabricate(:user) }
  #   let(:other_user)  { Fabricate(:user, id: 4) }
  #   let(:group)       { Fabricate(:group, user_id: 4) }

  #   before do
  #     user.join!(group)
  #   end

  #   let(:group_post) { other_user.notes.create!(content: "Foo!", group_id: 1) }
  #   subject { Note.from_groups_followed_by(user) }

  #   it { should include(group_post) }

  # end
end
