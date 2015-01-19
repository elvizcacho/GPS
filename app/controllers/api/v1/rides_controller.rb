module Api
    module V1
      class RidesController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # Returns an array of Rides
        # The number of rides that is returned depends on the Range Header parameter.
        #
        # GET /api/v1/rides
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   range - items=num-num
        # = Examples
        #   range: items=0-1
        #   resp = conn.get("/api/v1/rides", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   =>   [{
        #            "id": 1,
        #            "started_at": "2001-11-30T19:00:00.000Z",
        #            "ended_at": "2001-12-01T01:00:00.000Z",
        #            "average_speed": 33.2,
        #            "vehicle_id": 1,
        #            "user_id": 1,
        #            "gps_id": 1,
        #            "created_at": "2015-01-19T17:34:15.102Z",
        #            "updated_at": "2015-01-19T17:57:24.037Z"
        #        }, {
        #            "id": 2,
        #            "started_at": null,
        #            "ended_at": null,
        #            "average_speed": null,
        #            "vehicle_id": 1,
        #            "user_id": 1,
        #            "gps_id": 1,
        #            "created_at": "2015-01-19T17:34:15.103Z",
        #            "updated_at": "2015-01-19T17:34:15.103Z"
        #        }]
		#

      	def index
      		if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = Ride.limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: t('rides.index.response')}, status: 416 
           	end	
      	end

    	##
    	# Shows a ride.
    	#
        # Show
        # 
        # GET /api/v1/rides/:id
        #
        # params:
        #   id - number    [Required]
        #      
        # = Examples
        #   
        #   resp = conn.get("/api/v1/rides/2", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   =>   {
        #            "id": 1,
        #            "started_at": "2001-11-30T19:00:00.000Z",
        #            "ended_at": "2001-12-01T01:00:00.000Z",
        #            "average_speed": 33.2,
        #            "vehicle_id": 1,
        #            "user_id": 1,
        #            "gps_id": 1,
        #            "created_at": "2015-01-19T17:34:15.102Z",
        #            "updated_at": "2015-01-19T17:57:24.037Z"
        #        }
        #

      	def show
            begin
              user = Ride.find(params[:id])
              render json: ActiveSupport::JSON.encode(user), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
        end

        ##
        # Creates a new Ride.
        # 
        # POST /api/v1/rides
        #
        # params:
        #   started_at - datetime     
        #   ended_at - datetime       
        #   average_speed - number  
        #   vehicle_id - integer    [Required]
        #   user_id - integer       [Required]
        #   gps_id - integer        [Required]
        #
        # = Examples
        #   
        #   resp = conn.post("/api/v1/rides", "vehicle_id" => 1, "user_id" => 1, "gps_id" => 1, token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 201 - Created
        #
        #   resp.body
        #   => {
        #         "response": "Ride was created",
        #         "id": 2
        #      }
        #

        def create
          	response, status = Ride.create_from_model(:started_at => params[:started_at], :ended_at => params[:ended_at], :average_speed => params[:average_speed], :vehicle_id => params[:vehicle_id], :user_id => params[:user_id], :gps_id => params[:gps_id])
          	render :json => response, :status => status
        end

        ##
        # Deletes a Ride.
        # 
        # DELETE /api/v1/rides/:id
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required] 
        #   
        # = Examples
        #   
        #   resp = conn.delete("/api/v1/rides/3", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Ride 3 was deleted"
        #      }

        def destroy
            response, status = Ride.destroy_from_model(:id => params[:id])
            render :json => response, :status => status
        end

        ##
        # Updates a Ride.
        # 
        # PUT or PATCH /api/v1/rides/:id
        #
        # params:
        #   id - number             [Required]
        #   started_at - datetime     
        #   ended_at - datetime       
        #   average_speed - number  
        #   vehicle_id - integer    
        #   user_id - integer       
        #   gps_id - integer        
        #   
        # = Examples
        #   
        #   resp = conn.put("/api/v1/rides/3", "average_speed" => "33.5", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Ride 3 was updated"
        #      }

        def update
            response, status = Ride.update_from_model(:id => params[:id], :started_at => params[:started_at], :ended_at => params[:ended_at], :average_speed => params[:average_speed], :vehicle_id => params[:vehicle_id], :user_id => params[:user_id], :gps_id => params[:gps_id])
            render :json => response, :status => status
        end

      end
    end
end