class PayersController < ApplicationController
    def create
        new_payer = Payer.create!(payer_params)
        render json: new_payer, status: :created
    end

    def index 
        render json: Payer.all
    end

    def destroy
        payer = Payer.find(params[:id])
        payer.destroy
    end



    def payer_params
        params.permit(:payer_name)
    end


end
