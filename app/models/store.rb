class Store < ApplicationRecord
  has_many :users, through: :reviews

  has_many :reviews, dependent: :destroy

  has_many :likes
  has_many :liked_users, through: :likes, source: :user

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
end
