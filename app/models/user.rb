class User < ActiveRecord::Base
  attr_accessible :name, :first_name, :last_name, :zip_code, :email, :password,
                  :password_confirmation
  has_secure_password
  has_many :groups
  has_many :notes, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id",
                                        dependent: :destroy

  has_many :memberships, foreign_key: "group_member_id", dependent: :destroy
  has_many :group_memberships, through: :memberships

  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships,      foreign_key: "followed_id",
                                        class_name: "Relationship",
                                        dependent: :destroy

  has_many :followers, through: :reverse_relationships

  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :name, presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user).destroy
    #relationships.find_by_follower_id(other_user).destroy
  end

  def member?(group)
    memberships.find_by_group_membership_id(group.id)
  end

  def join!(group)
    memberships.create!(group_membership_id: group.id)
  end

  def leave!(group)
    memberships.find_by_group_membership_id(group.id).destroy
  end



  def feed
    Note.from_users_followed_by(self)
  end

  def group_feed
    Note.from_groups_followed_by(self)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
