class PagesController < ApplicationController
  def home
  	@rooms = Room.limit(3)
  end

  def search

    logger.debug "->Entering Search Function here!"

    logger.debug "Search City Param = #{params[:search_city].present?}"

  	if params[:search].present? && params[:search].strip != ""
  		session[:loc_search] = params[:search]
  	end

    if params[:search_city].present? && params[:search_city].strip != ""
  		session[:loc_search] = params[:search_city]
  	end

  	arrResult = Array.new

  	if session[:loc_search] && session[:loc_search] != ""
      logger.debug "#** Serch Parameters INSIDE #{session[:loc_search]}"
  		@rooms_address = Room.where(active: true).near(session[:loc_search], 50, order: 'distance')
  	else
  		@rooms_address = Room.where(active: true).all
  	end
    #@rooms_address = Room.where(active: true).all

  	@search = @rooms_address.ransack(params[:q])
  	@rooms = @search.result

  	@arrRooms = @rooms.to_a

    #logger.debug "Serch array= #{@arrRooms}"

  	if (params[:start_date] && params[:end_date] && !params[:start_date].empty? & !params[:end_date].empty?)

  		start_date = Date.parse(params[:start_date])
  		end_date = Date.parse(params[:end_date])

  		@rooms.each do |room|

  			not_available = room.reservations.where(
  					"((? <= start_date AND start_date <= ?)
  					OR (? <= end_date AND end_date <= ?)
  					OR (start_date < ? AND ? < end_date)) AND booking_status = ?",
  					start_date, end_date,
  					start_date, end_date,
  					start_date, end_date,
            3
  				).limit(1)

        logger.debug "***** NOT AVAILABLE = #{not_available.length}"

  			if not_available.length > 0
  				@arrRooms.delete(room)
  			end

  		end

  	end

  end
end
