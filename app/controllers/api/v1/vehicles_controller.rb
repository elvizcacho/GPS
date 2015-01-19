module Api
    module V1
      class VehiclesController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # Returns an array of Vehicles.
        # The number of vehicles that is returned depends on the Range Header parameter.
        #
        # GET /api/v1/vehicles
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   range - items=num-num
        # = Examples
        #   range: items=0-1
        #   resp = conn.get("/api/v1/vehicles", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   =>   [{
        #        "id": 1,
        #        "brand": "Lanos",
        #        "model": "2002",
        #        "license_plate": "SIC261",
        #        "company_id": 1,
        #        "created_at": "2015-01-19T01:36:31.729Z",
        #        "updated_at": "2015-01-19T01:36:31.729Z"
        #        }, {
        #        "id": 2,
        #        "brand": "Aveo",
        #        "model": "2008",
        #        "license_plate": "FTY264",
        #        "company_id": 1,
        #        "created_at": "2015-01-19T01:36:31.730Z",
        #        "updated_at": "2015-01-19T01:36:31.730Z"
        #        }]
		#

      	def index
      		if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = Vehicle.limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: t('vehicles.index.response')}, status: 416 
           	end	
      	end

    	##
    	# Shows a vehicle.
    	#
        # Show
        # 
        # GET /api/v1/vehicles/:id
        #
        # params:
        #   id - number    [Required]
        #      
        # = Examples
        #   
        #   resp = conn.get("/api/v1/vehicles/2", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   =>   {
        #            "id": 2,
        #            "brand": "Aveo",
        #            "model": "2008",
        #            "license_plate": "FTY264",
        #            "company_id": 1,
        #            "created_at": "2015-01-19T01:36:31.730Z",
        #            "updated_at": "2015-01-19T01:36:31.730Z"
        #        }
        #

      	def show
            begin
              user = Vehicle.find(params[:id])
              render json: ActiveSupport::JSON.encode(user), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
        end

        ##
        # Creates a new Vehicle.
        # 
        # POST /api/v1/vehicles
        #
        # params:
        #   brand - string          [Required]
        #   model - string          [Required]
        #   license_plate - string  [Required]
        #   company_id - integer    [Required]
        #
        # = Examples
        #   
        #   resp = conn.post("/api/v1/vehicles", "brand" => "Aveo", "model" => "2008", "license_plate" => "SIC261", "company_id" => "1", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 201 - Created
        #
        #   resp.body
        #   => {
        #         "response": "Vehicle was created",
        #         "id": 2
        #      }

        def create
          	response, status = Vehicle.create_from_model(:brand => params[:brand], :model => params[:model], :license_plate => params[:license_plate], :company_id => params[:company_id])
          	render :json => response, :status => status
        end

        ##
        # Deletes a Vehicle.
        # 
        # DELETE /api/v1/vehicles/:id
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required] 
        #   
        # = Examples
        #   
        #   resp = conn.delete("/api/v1/vehicles/3", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Vehicle 3 was deleted"
        #      }

        def destroy
            response, status = Vehicle.destroy_from_model(:id => params[:id], :token => params[:token])
            render :json => response, :status => status
        end

        ##
        # Updates a Vehicle.
        # 
        # PUT or PATCH /api/v1/vehicles/:id
        #
        # params:
        #   id - number                 [Required]
        #   brand - string               
        #   model - string              
        #   license_plate - string     
        #   company_id - integer
        #   
        # = Examples
        #   
        #   resp = conn.put("/api/v1/vehicles/3", "brand" => "Porche", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Vehicle 3 was updated"
        #      }

        def update
            response, status = Vehicle.update_from_model(:id => params[:id], :token => params[:token], :brand => params[:brand], :model => params[:model], :license_plate => params[:license_plate], :company_id => params[:company_id])
            render :json => response, :status => status
        end

        ##
        # Searchs for a vehicle by any attribute except created_at and updated_at
        #
        # GET /api/v1/vehicles/search
        #
        # header:
        #   range - items=num-num
        #
        # params:
        #   search - string     
        #   token - API token [Required]
        #      
        # = Examples
        #   
        #   header:
        #   range: items=0-1
        #   resp = conn.get("/api/v1/vehicles/search", "search" => "Aveo", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   => [{
        #        "id": 2,
        #        "brand": "Aveo",
        #        "model": "2008",
        #        "license_plate": "FTY264",
        #        "company_id": 1,
        #        "created_at": "2015-01-19T02:32:16.676Z",
        #        "updated_at": "2015-01-19T02:32:16.676Z"
        #       }]
        #

        def search
          if request.headers['Range']
            from, to = get_range_header()
            limit = to - from + 1
            query_response = Vehicle.search(params[:search]).limit(limit).offset(from).to_a
            render json: ActiveSupport::JSON.encode(query_response), status: 206
          else
            render json: {response: t('vehicles.index.response')}, status: 416 
          end
        end

      end
    end
end