require 'spec_helper'

describe Membership do

  let(:member) { Fabricate(:user) }
  let(:user2) { Fabricate(:user) }
  let(:group_membership) { Fabricate(:group, user_id: user2.id) }
  let(:membership) do
    member.memberships.build(group_membership_id: group_membership.id)
  end

  subject { membership }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Membership.new(group_membership_id: group_membership.id)
        should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

  describe "membership methods" do
    it { should respond_to(:member) }
    it { should respond_to(:group_membership) }
    # its(:member) { should == member }
    its(:group_membership) { should == group_membership }
  end

  describe "when group id is not present" do
    before { membership.group_membership_id = nil }
    it { should_not be_valid }
  end

  describe "when user id is not present" do
    before { membership.group_member_id = nil }
    it { should_not be_valid }
  end
end