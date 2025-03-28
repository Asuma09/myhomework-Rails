class Post < ApplicationRecord
    validates :username, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
  has_many :likes, dependent: :destroy
end
