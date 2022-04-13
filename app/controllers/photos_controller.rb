class PhotosController < ApplicationController

	def destroy
		@photo = Photo.find(params[:id])
		room = @photo.room

		@photo.destroy
		@photos = Photo.where(room_id: room.id)

		respond_to :js
	end

	def photo_params
  	#params.require(:photo).permit(:name, :address, :price, :listings, :bathrooms, :parking_spaces, :description, :details, :photo, :photo_cache)
		params.require(:photo).permit(:room_id, :image, :image_cache)
	end
end
