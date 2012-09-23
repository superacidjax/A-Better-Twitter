class Membership < ActiveRecord::Base
  attr_accessible :group_membership_id, :group_member_id

  belongs_to :member, class_name: "User"
  belongs_to :group_membership, class_name: "Group"

  validates :group_member_id, presence: true
  validates :group_membership_id, presence: true
end
