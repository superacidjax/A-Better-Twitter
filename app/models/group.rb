class Group < ActiveRecord::Base
  attr_accessible :category, :description, :name, :user_id

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 255 }
  validates :category, presence: true, length: {maximum: 30 }
  belongs_to :user

  default_scope order: 'groups.name'
end
