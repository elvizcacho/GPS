class VehiclesControllerActions < ActiveRecord::Migration
  def change
  	#creates controller
  	ControllerAction.create(:name => "vehicles")
  	controller = ControllerAction.where(name: 'vehicles', controller_action_id: nil).first
  	
  	#creates actions
  	ControllerAction.create(:name => "index", :controller_action_id => controller.id)
    ControllerAction.create(:name => "show", :controller_action_id => controller.id)
    ControllerAction.create(:name => "create", :controller_action_id => controller.id)
    ControllerAction.create(:name => "destroy", :controller_action_id => controller.id)
    ControllerAction.create(:name => "update", :controller_action_id => controller.id)
    ControllerAction.create(:name => "search", :controller_action_id => controller.id)

  	actions = []
  	actions << controller.controller_actions.where(name: 'index').first
    actions << controller.controller_actions.where(name: 'show').first
    actions << controller.controller_actions.where(name: 'create').first
    actions << controller.controller_actions.where(name: 'destroy').first
    actions << controller.controller_actions.where(name: 'update').first
    actions << controller.controller_actions.where(name: 'search').first

  	#asigns actions to role
  	admin = Role.find(1)
  	admin.controller_actions << actions

  	#creates four vehicles to test
  	Vehicle.create(:brand => "Lanos", :model => "2002", :license_plate => "SIC261", :company_id => 1)
  	Vehicle.create(:brand => "Aveo", :model => "2008", :license_plate => "FTY264", :company_id => 1)
  	Vehicle.create(:brand => "Ford", :model => "2011", :license_plate => "TYU457", :company_id => 2)
  	Vehicle.create(:brand => "Chevrolet", :model => "2005", :license_plate => "GTY945", :company_id => 2)
  	
  end
end
