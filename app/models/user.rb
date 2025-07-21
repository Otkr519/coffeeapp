class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews, dependent: :destroy
  has_many :stores, through: :reviews

  has_many :likes, dependent: :destroy
  has_many :liked_stores, through: :likes, source: :store
end
