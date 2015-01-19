class RidesControllerActions < ActiveRecord::Migration
  def change
  	#creates controller
  	ControllerAction.create(:name => "rides")
  	controller = ControllerAction.where(name: 'rides', controller_action_id: nil).first
  	
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

  	#creates four rides to test
  	Ride.create(:started_at => DateTime.new(2001,12,1,0,0,0,'+5'), :ended_at => DateTime.new(2001,12,1,6,0,0,'+5'), :average_speed => 40.2, :vehicle_id => 1, :user_id => 1, :gps_id => 1)
  	Ride.create(:started_at => nil, :ended_at => nil, :average_speed => nil, :vehicle_id => 1, :user_id => 1, :gps_id => 1)
  	Ride.create(:started_at => nil, :ended_at => nil, :average_speed => nil, :vehicle_id => 4, :user_id => 1, :gps_id => 2)
  	Ride.create(:started_at => DateTime.new(2001,12,15,0,0,0,'+5'), :ended_at => DateTime.new(2001,12,15,10,0,0,'+5'), :average_speed => 55.2, :vehicle_id => 4, :user_id => 1, :gps_id => 2)
  end
end
