class Amenity < ApplicationRecord
  # has_and_belongs_to_many :rooms
  has_many :room_amenities
  has_many :rooms, through: :room_amenities
end
