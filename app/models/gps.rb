class Gps < ActiveRecord::Base
	has_many :rides

	validates :battery, numericality: true

	def self.create_from_model(hash)
    	error_messages = self.create(:battery => hash[:battery].nil? ? 0.0 : hash[:battery]).errors.messages #creates a ride or gets the error messsages
      	if error_messages.to_a.length != 0  #If there are errors I return them
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('gps.create.response'), id: self.last.id}, 201
        end
	end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  #deletes this gps
            return {response: I18n.t('gps.delete.response', id: hash[:id])}, 200
        rescue Exception => e #If gps is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            gps = self.find(hash[:id]) #gets the gps
            gps.assign_attributes(
              	:battery => hash[:battery].nil? ? gps.battery : hash[:battery]
            ) #assign the model attributes but not save
            if gps.valid? #valids the attributes
               	gps.save  #saves the attributes into table gps
               	return {response: I18n.t('gps.update.response', id: hash[:id])}, 200
            else
               	error_messages = gps.errors.messages  #if there are errors, these ones are returned
               	return {errors: error_messages}, 400
            end
        rescue Exception => e #If gps is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end
end
