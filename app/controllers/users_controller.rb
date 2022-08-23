class UsersController < ApplicationController

    
    skip_before_action :authorize, only: [:create]

    rescue_from ActiveRecord::RecordInvalid, with: :user_data_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :user_data_not_found

    def create
        user=User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find(session[:user_id])
        render json: user
    end

    private
    
  

    def user_params
        params.permit(:username,:password,:password_confirmation)
    end

    def user_data_invalid(error_hash)
        render json: { errors: error_hash.record.errors.full_messages }, status: :unprocessable_entity
    end

    def user_data_not_found
        render json: { error: "Please login to view your account page." }, status: :not_found
    end
end
