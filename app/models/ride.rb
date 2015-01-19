class Ride < ActiveRecord::Base
	belongs_to 	:user
	belongs_to 	:gps
	belongs_to 	:vehicle
	has_many 	:coordinates

	validates :vehicle_id, presence: true
	validates :user_id, presence: true
	validates :gps_id, presence: true
    validates :average_speed, numericality: true

	def self.create_from_model(hash)
    	error_messages = self.create(:started_at => hash[:started_at], :ended_at => hash[:ended_at], :average_speed => hash[:average_speed].nil? ? 0.0 : hash[:average_speed], :vehicle_id => hash[:vehicle_id], :user_id => hash[:user_id], :gps_id => hash[:gps_id]).errors.messages #creates a ride or gets the error messsages
      	if error_messages.to_a.length != 0  #If there are errors I return them
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('rides.create.response'), id: self.last.id}, 201
        end
	end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  #deletes this ride
            return {response: I18n.t('rides.delete.response', id: hash[:id])}, 200
        rescue Exception => e #If ride is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            ride = self.find(hash[:id]) #gets the ride
            ride.assign_attributes(
            	:started_at => hash[:started_at].nil? ? ride.started_at : hash[:started_at],
            	:ended_at => hash[:ended_at].nil? ? ride.ended_at : hash[:ended_at],
            	:average_speed => hash[:average_speed].nil? ? ride.average_speed : hash[:average_speed],
            	:vehicle_id => hash[:vehicle_id].nil? ? ride.vehicle_id : hash[:vehicle_id],
            	:user_id => hash[:user_id].nil? ? ride.user_id : hash[:user_id],
            	:gps_id => hash[:gps_id].nil? ? ride.gps_id : hash[:gps_id]
            ) #assign the model attributes but not save
            if ride.valid? #valids the attributes
               	ride.save  #saves the attributes into table rides
               	return {response: I18n.t('rides.update.response', id: hash[:id])}, 200
            else
               	error_messages = ride.errors.messages  #if there are errors, these ones are returned
               	return {errors: error_messages}, 400
            end
        rescue Exception => e #If ride is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

end
