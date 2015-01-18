class Vehicle < ActiveRecord::Base
	belongs_to :company
	has_many :rides
end
