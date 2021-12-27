class TransactionsController < ApplicationController

    def create
        payer_name = trans_params[:payer_name]
        if payer_name == ""
            render json: { error: 'Empty Payer Name'}
        end

        timestamp = trans_params[:timestamp]
        if timestamp == ""
            render json: { error: 'Empty Timestamp'}
        end

        points = trans_params[:points]
        if points.nil? 
            render json: { error: 'No Points Were Given'}
        end
        payer = Payer.find_by(payer_name: trans_params[:payer_name])

        if payer.nil?
            payer = create_new_payer(trans_params)
        end

        

        new_balance = payer.balance + trans_params[:points]
        if new_balance < 0     
        
        render json: { error: 'Insufficient balance'}
        else
            payer.update(balance: new_balance)
            new_transaction = Transaction.create!(trans_params)
            render json: new_transaction, status: :created
        end
    end

    def create_new_payer(trans_params)
        Payer.create(payer_name: trans_params[:payer_name], balance: 0, amount_spent: 0)
    end

    def index  
        render json: Transaction.all
    end

    def destroy
        transaction = Transaction.find(params[:id])
        transaction.destroy
    end


    def trans_params
        params.permit(:payer_name, :points, :user_id, :timestamp)
    end
    
end

