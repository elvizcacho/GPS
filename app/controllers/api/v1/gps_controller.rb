module Api
    module V1
      class GpsController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # Returns an array of GPSs
        # The number of GPSs that is returned depends on the Range Header parameter.
        #
        # GET /api/v1/gps
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   range - items=num-num
        # = Examples
        #   range: items=0-2
        #   resp = conn.get("/api/v1/gps", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   =>   [{
        #            "id": 1,
        #            "battery": 50.5,
        #            "created_at": "2015-01-19T23:01:05.896Z",
        #            "updated_at": "2015-01-19T23:01:05.896Z"
        #        }, {
        #            "id": 2,
        #            "battery": 40.1,
        #            "created_at": "2015-01-19T23:01:05.898Z",
        #            "updated_at": "2015-01-19T23:01:05.898Z"
        #        }, {
        #            "id": 3,
        #            "battery": 0.0,
        #            "created_at": "2015-01-19T23:04:08.433Z",
        #            "updated_at": "2015-01-19T23:04:08.433Z"
        #        }]
		#

      	def index
      		if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = Gps.limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: t('gps.index.response')}, status: 416 
           	end	
      	end

    	##
    	# Shows a ride.
    	#
        # Show
        # 
        # GET /api/v1/gps/:id
        #
        # params:
        #   id - number    [Required]
        #      
        # = Examples
        #   
        #   resp = conn.get("/api/v1/gps/2", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   =>   {
        #            "id": 2,
        #            "battery": 40.1,
        #            "created_at": "2015-01-19T23:01:05.898Z",
        #            "updated_at": "2015-01-19T23:01:05.898Z"
        #        }
        
      	def show
            begin
              gps = Gps.find(params[:id])
              render json: ActiveSupport::JSON.encode(gps), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
        end

        ##
        # Creates a new GPS.
        # 
        # POST /api/v1/gps
        #
        # params:
        #   battery - number
        #
        # = Examples
        #   
        #   resp = conn.post("/api/v1/gps", "battery" => 50, token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 201 - Created
        #
        #   resp.body
        #   => {
        #         "response": "GPS was created",
        #         "id": 2
        #      }
        #

        def create
          	response, status = Gps.create_from_model(:battery => params[:battery])
          	render :json => response, :status => status
        end

        ##
        # Deletes a GPS.
        # 
        # DELETE /api/v1/gps/:id
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required] 
        #   
        # = Examples
        #   
        #   resp = conn.delete("/api/v1/gps/3", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "GPS 3 was deleted"
        #      }

        def destroy
            response, status = Gps.destroy_from_model(:id => params[:id])
            render :json => response, :status => status
        end

        ##
        # Updates a GPS.
        # 
        # PUT or PATCH /api/v1/gps/:id
        #
        # params:
        #   id - number             [Required]
        #   battery - number
        #   
        # = Examples
        #   
        #   resp = conn.put("/api/v1/gps/3", "battery" => "50.6", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "GPS 3 was updated"
        #      }

        def update
            response, status = Gps.update_from_model(:id => params[:id], :battery => params[:battery])
            render :json => response, :status => status
        end

      end
    end
end