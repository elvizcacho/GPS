class Company < ActiveRecord::Base
	
	has_many :vehicles

	validates :name, presence: true, uniqueness: true
	validates :phone, presence: true, length: {minimum: 7}
	validates :representative, presence: true, length: {minimum: 3}
	validates :nit, presence: true, uniqueness: true
	validates :address, presence: true
	validates :email, presence: true, email: true

    def self.create_from_model(hash)
    	error_messages = self.create(:name => hash[:name], :phone => hash[:phone], :representative => hash[:representative], :nit => hash[:nit], :address => hash[:address], :email => hash[:email]).errors.messages #creates vehicle or gets the error messsages
      	if error_messages.to_a.length != 0  #If there are errors I return them
            return {errors: error_messages}, 400
        else
            return {response: I18n.t('company.create.response'), role_id: self.last.id}, 201
        end
    end

    def self.destroy_from_model(hash)
    	begin
            self.find(hash[:id]).destroy  #deletes this company
            return {response: I18n.t('company.delete.response', id: hash[:id])}, 200
        rescue Exception => e #If company is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.update_from_model(hash)
    	begin
            company = self.find(hash[:id]) #gets the company
            company.assign_attributes(
            	:name => hash[:name].nil? ? company.name : hash[:name],
            	:phone => hash[:phone].nil? ? company.phone : hash[:phone],
            	:representative => hash[:representative].nil? ? company.representative : hash[:representative],
            	:nit => hash[:nit].nil? ? company.nit : hash[:nit],
            	:address => hash[:address].nil? ? company.address : hash[:address],
            	:email => hash[:email].nil? ? company.email : hash[:email]
            ) #assign the model attributes but not save
            if company.valid? #valids the attributes
               	company.save  #saves the attributes into table company
               	return {response: I18n.t('company.update.response', id: hash[:id])}, 200
            else
               	error_messages = company.errors.messages  #if there are errors, these ones are returned
               	return {errors: error_messages}, 400
            end
        rescue Exception => e #If company is not found an exception is arise.
            return {response: "#{e}"}, 404
        end
    end

    def self.search(search)
        search_condition = "%" + search + "%"
        self.where('name LIKE ? OR phone LIKE ? OR representative LIKE ? OR nit LIKE ? OR address LIKE ? OR email LIKE ?', search_condition, search_condition, search_condition, search_condition, search_condition, search_condition)
    end

end