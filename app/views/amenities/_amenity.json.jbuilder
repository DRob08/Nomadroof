json.extract! amenity, :id, :name, :popularity, :created_at, :updated_at
json.url amenity_url(amenity, format: :json)
