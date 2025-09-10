class Store < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews

  has_many :likes
  has_many :liked_users, through: :likes, source: :user

  geocoded_by :address
  after_validation :geocode

  mount_uploader :image, ImageUploader

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  def self.ransackable_attributes(auth_object = nil)
    ["address", "countries", "name", "roast_level", "prefecture_id"]
  end
  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  validates :name, presence: true
  validates :prefecture_id, presence: true
  validates :address, presence: true
  validates :countries, presence: true
  validates :roast_level, presence: true

end
