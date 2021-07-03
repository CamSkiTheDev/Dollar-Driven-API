class UsersController < ApplicationController
    before_action :authorized, only: [:validate_jwt]

    def create
        @user = User.find_by(email: user_params[:email])

        if(@user)
            render json: {error: "A user with that email already exist"}, status: 400
        else
            @user = User.create(user_params)
            if @user.valid?
                token = encode_token({user_id: @user.id})
                render json: {user: @user, token: token}, status: 200
            else
                render json: {error: "Invalid username or password"}, status: 400
            end
        end
    end

    def login
        @user = User.find_by(email: user_params[:email])
        if @user && @user.authenticate(user_params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}, status: 200
        else
            render json: {error: "Invalid username or password"}, status: 401
        end
    end

    def validate_jwt
        render json: {user: @user}
    end

    private

    def user_params
        params.permit(:full_name, :email, :password)
    end
end
