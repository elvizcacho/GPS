module Api
    module V1
      class CompaniesController < ApplicationController
      	before_filter :restrict_access, :except => []

      	##
        # Returns an array of Companies. 
        # The number of companies that is returned depends on the Range Header parameter.
        #
        # GET /api/v1/companies
        #
        # params:
        #   token - API token [Required]
        # 
        # header:
        #   range - items=num-num
        # = Examples
        #   range: items=0-1
        #   resp = conn.get("/api/v1/companies", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   =>   [{
        #          "id": 1,
        #          "name": "Company1",
        #          "phone": "5608937",
        #          "representative": "Laura Herrera",
        #          "nit": "123456789",
        #          "address": "CALLE 5A # 29 12",
        #          "email": "lauraherra@gmail.com",
        #          "created_at": "2015-01-18T17:50:12.331Z",
        #          "updated_at": "2015-01-18T17:50:12.331Z"
        #          }, {
        #          "id": 2,
        #          "name": "Company2",
        #          "phone": "2776584",
        #          "representative": "Jose Rodriguez",
        #          "nit": "987654321",
        #          "address": "CALLE 100 # 14 83",
        #          "email": "joserodriguez@gmail.com",
        #          "created_at": "2015-01-18T17:50:12.332Z",
        #          "updated_at": "2015-01-18T17:50:12.332Z"
        #        }]
		    #

      	def index
      		if request.headers['Range']
              from, to = get_range_header()
              limit = to - from + 1
              query_response = Company.limit(limit).offset(from).to_a
              render json: ActiveSupport::JSON.encode(query_response), status: 206
            else
              render json: {response: t('companies.index.response')}, status: 416 
           	end	
      	end

    	##
    	# Shows a company.
    	#
        # Show
        # 
        # GET /api/v1/companies/:id
        #
        # params:
        #   id - number    [Required]
        #      
        # = Examples
        #   
        #   resp = conn.get("/api/v1/companies/2", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   =>   {
        #          "id": 2,
        #          "name": "Company2",
        #          "phone": "2776584",
        #          "representative": "Jose Rodriguez",
        #          "nit": "987654321",
        #          "address": "CALLE 100 # 14 83",
        #          "email": "joserodriguez@gmail.com",
        #          "created_at": "2015-01-18T18:22:29.102Z",
        #          "updated_at": "2015-01-18T18:22:29.102Z"
        #        }

      	def show
            begin
              user = Company.find(params[:id])
              render json: ActiveSupport::JSON.encode(user), status: 200  
            rescue Exception => e
              render json: {response: "#{e}"}, status: 404
            end
        end

        ##
        # Creates a new Company.
        # 
        # POST /api/v1/companies
        #
        # params:
        #   name - string               [Required]
        #   phone - string              [Required]
        #   representative - string     [Required]
        #   nit - string                [Required]
        #   address - string            [Required]
        #   email - string              [Required]
        #
        # = Examples
        #   
        #   resp = conn.post("/api/v1/companies", "name" => "Company2", "phone" => "2776584", "representative" => "Jose Rodriguez", "nit" => "987654321", "address" => "CALLE 100 # 14 83", "email" => "joserodriguez@gmail.com", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 201 - Created
        #
        #   resp.body
        #   => {
        #         "response": "Company was created",
        #         "id": 2
        #      }

        def create
          	response, status = Company.create_from_model(:name => params[:name], :phone => params[:phone], :representative => params[:representative], :nit => params[:nit], :address => params[:address], :email => params[:email])
          	render :json => response, :status => status
        end

        ##
        # Deletes a Company.
        # 
        # DELETE /api/v1/companies/:id
        #
        # params:
        #   id - number       [Required]
        #   token - API token [Required] 
        #   
        # = Examples
        #   
        #   resp = conn.delete("/api/v1/companies/3", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Company 3 was deleted"
        #      }

        def destroy
            response, status = Company.destroy_from_model(:id => params[:id])
            render :json => response, :status => status
        end

        ##
        # Updates a Company.
        # 
        # PUT or PATCH /api/v1/companies/:id
        #
        # params:
        #   id - number                 [Required]
        #   name - string               
        #   phone - string              
        #   representative - string     
        #   nit - string                
        #   address - string            
        #   email - string              
        #   
        # = Examples
        #   
        #   resp = conn.put("/api/v1/companies/3", "name" => "Cocoa", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 200 - OK
        #
        #   resp.body
        #   => {
        #         "response": "Company 3 was updated"
        #      }

        def update
            response, status = Company.update_from_model(:id => params[:id], :token => params[:token], :name => params[:name], :phone => params[:phone], :representative => params[:representative], :nit => params[:nit], :address => params[:address], :email => params[:email])
            render :json => response, :status => status
        end

        ##
        # Searchs for a company by any attribute except created_at and updated_at
        #
        # GET /api/v1/companies/search
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
        #   resp = conn.get("/api/v1/companies/search", "search" => "Company2", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   => [{
        #        "id": 2,
        #        "name": "Company2",
        #        "phone": "2776584",
        #        "representative": "Jose Rodriguez",
        #        "nit": "987654321",
        #        "address": "CALLE 100 # 14 83",
        #        "email": "joserodriguez@gmail.com",
        #        "created_at": "2015-01-18T19:39:01.410Z",
        #        "updated_at": "2015-01-18T19:39:01.410Z"
        #    }]

        def search
          if request.headers['Range']
            from, to = get_range_header()
            limit = to - from + 1
            query_response = Company.search(params[:search]).limit(limit).offset(from).to_a
            render json: ActiveSupport::JSON.encode(query_response), status: 206
          else
            render json: {response: t('companies.index.response')}, status: 416 
          end
        end

        ##
        # Gets the vehicles of the company
        #
        # GET /api/v1/companies/:id/vehicles
        #
        # header:
        #   range - items=num-num
        #
        # params:
        #   id - integer     
        #   token - API token [Required]
        #      
        # = Examples
        #   
        #   header:
        #   range: items=0-2
        #   resp = conn.get("/api/v1/companies/1/vehicles", "token" => "dcbb7b36acd4438d07abafb8e28605a4")
        #   
        #   resp.status
        #   => 206 - Partial Content
        #
        #   resp.body
        #   => [{
        #        "id": 1,
        #        "brand": "Lanos",
        #        "model": "2002",
        #        "license_plate": "SIC261",
        #        "company_id": 1,
        #        "created_at": "2015-01-19T16:15:26.274Z",
        #        "updated_at": "2015-01-19T16:15:26.274Z"
        #        }, {
        #        "id": 2,
        #        "brand": "Aveo",
        #        "model": "2008",
        #        "license_plate": "FTY264",
        #        "company_id": 1,
        #        "created_at": "2015-01-19T16:15:26.275Z",
        #        "updated_at": "2015-01-19T16:15:26.275Z"
        #        }, {
        #        "id": 5,
        #        "brand": "Porche",
        #        "model": "2000",
        #        "license_plate": "XRT123",
        #        "company_id": 1,
        #        "created_at": "2015-01-19T16:21:03.643Z",
        #        "updated_at": "2015-01-19T16:21:03.643Z"
        #        }]
        #

        def get_vehicles
          if request.headers['Range']
            from, to = get_range_header()
            limit = to - from + 1
            query_response = Company.find(params[:id]).vehicles.limit(limit).offset(from).to_a
            render json: ActiveSupport::JSON.encode(query_response), status: 206
          else
            render json: {response: t('companies.index.response')}, status: 416 
          end
        end

      end
    end
end