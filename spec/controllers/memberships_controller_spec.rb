require 'spec_helper'

describe MembershipsController do

  let(:user) { Fabricate(:user) }
  let(:group) { Fabricate(:group, user_id: 2) }

  before { sign_in user }

  describe "creating a relationship with Ajax" do

    it "should increment the Membership count" do
      expect do
        xhr :post, :create, membership: { group_membership_id: group.id }
      end.to change(Membership, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, membership: { group_membership_id: group.id }
      response.should be_success
    end
  end

  describe "destroying a membership with Ajax" do

    before { user.join!(group) }
    let(:membership) { user.memberships.find_by_group_membership_id(group.id) }

    it "should decrement the Membership count" do
      expect do
        xhr :delete, :destroy, id: membership.id
      end.to change(Membership, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: membership.id
      response.should be_success
    end
  end
end