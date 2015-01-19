class Vehicle < ActiveRecord::Base
	belongs_to :company
	has_many :rides

	validates :brand, presence: true
	validates :model, presence: true, numericality: { only_integer: true }
	validates :license_plate, presence: true, license_plate: true, uniqueness: true
	validates :company_id, presence: true

	def self.create_from_model(hash)
    	error_messages = self.create(:brand => hash[:brand], :model => hash[:model], :license_plate => hash[:license_plate].upcase, :company_id => hash[:company_id]).errors.messages #creates vehicle or gets the error messsages
      	if error_messages.to_a.length != 0  #If there are errors I return them
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('vehicles.create.response'), role_id: self.last.id}, 201
        end
	end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  #deletes this vehicle
            return {response: I18n.t('vehicles.delete.response', id: hash[:id])}, 200
        rescue Exception => e #If vehicle is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            vehicle = self.find(hash[:id]) #gets the vehicle
            vehicle.assign_attributes(
            	:brand => hash[:brand].nil? ? vehicle.brand : hash[:brand],
            	:model => hash[:model].nil? ? vehicle.model : hash[:model],
            	:license_plate => hash[:license_plate].nil? ? vehicle.license_plate : hash[:license_plate].upcase,
            	:company_id => hash[:company_id].nil? ? vehicle.company_id : hash[:company_id]
            ) #assign the model attributes but not save
            if vehicle.valid? #valids the attributes
               	vehicle.save  #saves the attributes into table vehicle
               	return {response: I18n.t('vehicles.update.response', id: hash[:id])}, 200
            else
               	error_messages = vehicle.errors.messages  #if there are errors, these ones are returned
               	return {errors: error_messages}, 400
            end
        rescue Exception => e #If vehicle is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.search(search)
        search_condition = "%" + search + "%"
        self.where('brand LIKE ? OR model LIKE ? OR license_plate LIKE ?', search_condition, search_condition, search_condition)
    end
end
