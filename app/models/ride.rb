class Ride < ActiveRecord::Base
	belongs_to 	:user
	belongs_to 	:gps
	belongs_to 	:vehicle
	has_many 	:coordinates
end
