class GpsControllerActions < ActiveRecord::Migration
  def change
  	#creates controller
  	ControllerAction.create(:name => "gps")
  	controller = ControllerAction.where(name: 'gps', controller_action_id: nil).first
  	
  	#creates actions
  	ControllerAction.create(:name => "index", :controller_action_id => controller.id)
    ControllerAction.create(:name => "show", :controller_action_id => controller.id)
    ControllerAction.create(:name => "create", :controller_action_id => controller.id)
    ControllerAction.create(:name => "destroy", :controller_action_id => controller.id)
    ControllerAction.create(:name => "update", :controller_action_id => controller.id)
    
  	actions = []
  	actions << controller.controller_actions.where(name: 'index').first
    actions << controller.controller_actions.where(name: 'show').first
    actions << controller.controller_actions.where(name: 'create').first
    actions << controller.controller_actions.where(name: 'destroy').first
    actions << controller.controller_actions.where(name: 'update').first
    
  	#asigns actions to role
  	admin = Role.find(1)
  	admin.controller_actions << actions

  	#creates 2 gps to test
  	Gps.create(:battery => 50.5)
  	Gps.create(:battery => 40.1)
  end
end
