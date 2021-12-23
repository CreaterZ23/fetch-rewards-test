class PayersController < ApplicationController
    def create
        new_payer = Payer.create!(payer_params)
        render json: new_payer, status: :created
    end

    def index 
        render json: Payer.all
    end



    def payer_params
        params.permit(:partner)
    end


end
