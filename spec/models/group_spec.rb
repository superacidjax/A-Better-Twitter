require 'spec_helper'

describe Group do

  let(:user) { Fabricate(:user) }

  before { @group = user.groups.build(name: "Lorem ipsum", description: "This is a group",
      category: "Cats") }

  subject { @group }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:category) }
  it { should respond_to(:user) }

  its(:user) { should == user }

  it { should be_valid }

  describe "when a user id is not present" do
    before { @group.user_id = nil }
    it {should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Group.new(user_id: "1")
      should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe "with no name" do
    before { @group.name = " " }
    it { should_not be_valid }
  end

  describe "with a name that is too long" do
    before { @group.name = "z" * 51 }
    it { should_not be_valid }
  end

  describe "with a description that is too long" do
    before { @group.description = "z" * 256 }
    it { should_not be_valid }
  end

  describe "with no description" do
    before { @group.description = " " }
    it { should_not be_valid }
  end

  describe "with no category" do
    before { @group.category = " "}
    it { should_not be_valid }
  end

  describe "with a too long category" do
    before { @group.category = "c" * 31 }
    it { should_not be_valid }
  end
end
