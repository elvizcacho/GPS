require 'test_helper'

module Api
  module V1
	  class RidesControllerTest < ActionController::TestCase
	  	# index
  			test "should get 2 rides" do
  				@request.headers["Range"] = 'items=0-1'
    			get :index, {:token => '0474eee1800353d61a5de09259ee2f9e'}
    			obj = ActiveSupport::JSON.decode(@response.body)
    			assert_response(206, '206 status code')
    			assert(obj.length == 2, 'it returned 2 rides')
    		end

        test 'if range header is not set, server response with a 416 status code' do
          get :index, {:token => '0474eee1800353d61a5de09259ee2f9e'}
          assert_response(416, '416 status code')
        end

      # destroy
        test 'if the token is not valid, server response with a 401 status code # destroy' do
          delete :destroy, {:id => '20'}
          assert_response(401, '401 status code')
        end

        test 'only admin can delete rides' do
          delete :destroy, {:id => 2, :token => '0474eee1800353d61a5de09259ee2f9e'}
          begin
            role = Ride.find(2)
          rescue Exception => e
            puts "#############{e}################"
          end
          assert_nil(role,'ride was deleted by admin')
        end

      # update
        test 'if the token is not valid, server response with a 401 status code # update' do
          put :update, {:id => 1}
          assert_response(401, '401 status code')
        end

        test 'only admin can update a ride' do
          put :update, {:id => 1, :token => '0474eee1800353d61a5de09259ee2f9e', :average_speed => 33.2}
          puts "#{Ride.find(1).average_speed}"
          assert(Ride.find(1).average_speed == 33.2, 'ride was updated by admin')
        end

	  end
  end
end