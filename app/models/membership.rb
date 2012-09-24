class Membership < ActiveRecord::Base
  attr_accessible :group_membership_id, :group_member_id, :role

  belongs_to :member, class_name: "User"
  belongs_to :group_membership, class_name: "Group"

  validates :group_member_id, presence: true
  validates :group_membership_id, presence: true


  def make_mod
    self.role = 'moderator'
    save!
  end

  def kill_mod
    self.role = 'user'
    save!
  end

end
