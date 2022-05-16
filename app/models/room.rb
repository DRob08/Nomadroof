class Room < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :room_amenities
  has_many :amenities, through: :room_amenities

  #has_and_belongs_to_many :amenitites
  #has_many :amenitites, through: :room_amenities

  accepts_nested_attributes_for :room_amenities, reject_if: :all_blank, :allow_destroy => true

  geocoded_by :address_val do |room, results|
    if results.empty?
      geo = Geocoder.search(job.city).first
      if geo.present?
        room.latitude = geo.latitude
        room.longitude = geo.longitude
      end
    else
      room.latitude = results.first.latitude
      room.longitude = results.first.longitude
    end
  end
  #after_validation :geocode, if: :address_changed?
  after_validation :geocode, :if => lambda{ |obj| obj.address_changed? or obj.city_changed? or obj.postal_code_changed?}


  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  validates :listing_name, presence: true, length: {maximum: 50}
  validates :summary, presence: true, length: {maximum: 500}
  validates :address, presence: true
  validates :country, presence: true
  validates :city, presence: true
  #validates :postal_code, presence: true

  def average_rating
    reviews.count == 0 ? 0 : reviews.average(:star).round(2)
  end

  def country_name
    mycountry = ISO3166::Country[country]
    mycountry.translations[I18n.locale.to_s] || mycountry.name
  end

  def address_val
    logger.debug [address, city, postal_code, country].compact.join(', ')
    [address, city, country].compact.join(', ')
  end
end
