class Coordinate < ActiveRecord::Base
	belongs_to :ride

	validates :ride_id, presence: true
	validates :latitude, presence: true, numericality: true
	validates :longitude, presence: true, numericality: true

	def self.create_from_model(hash)
    	error_messages = self.create(:ride_id => hash[:ride_id], :latitude => hash[:latitude], :longitude => hash[:longitude]).errors.messages #creates a coordinate or gets the error messsages
      	if error_messages.to_a.length != 0  #If there are errors I return them
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('coordinates.create.response'), id: self.last.id}, 201
        end
	end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  #deletes this coordinate
            return {response: I18n.t('coordinates.delete.response', id: hash[:id])}, 200
        rescue Exception => e #If coordinate is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            coordinate = self.find(hash[:id]) #gets the coordinate
            coordinate.assign_attributes(
              	:ride_id => hash[:ride_id],
              	:latitude => hash[:latitude],
              	:longitude => hash[:longitude]
            ) #assign the model attributes but not save
            if coordinate.valid? #valids the attributes
               	coordinate.save  #saves the attributes into table coordinates
               	return {response: I18n.t('coordinates.update.response', id: hash[:id])}, 200
            else
               	error_messages = coordinate.errors.messages  #if there are errors, these ones are returned
               	return {errors: error_messages}, 400
            end
        rescue Exception => e #If coordinate is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end
end
