class Group < ActiveRecord::Base
  attr_accessible :category, :description, :name, :user_id

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :category, presence: true, length: {maximum: 30 }
  belongs_to :user
  has_many :memberships, foreign_key: "group_membership_id", dependent: :destroy
  has_many :members, through: :memberships, source: "user_id"
  has_many :notes

  default_scope order: 'groups.name'

  CATEGORIES = ['hobbies', 'parenting', 'gaming', 'sports', 'technology',
                'politics', 'NSFW', 'music', 'travel', 'education',
                'home & garden', 'entertainment']

  def feed
    Note.find_by_group_id(group.id)
  end

end
