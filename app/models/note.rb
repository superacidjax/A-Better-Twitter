class Note < ActiveRecord::Base
  attr_accessible :content, :group_id
  belongs_to :user
  belongs_to :group

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 200 }
  validates :group_id, presence: true

  default_scope order: 'notes.created_at DESC'

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  # MY_GROUP_NAMES = ['hobbies', 'parenting', 'gaming', 'sports', 'technology',
  #               'politics', 'NSFW', 'music', 'travel', 'education',
  #               'home & garden', 'entertainment']
end
