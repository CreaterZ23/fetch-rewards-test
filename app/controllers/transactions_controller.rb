class TransactionsController < ApplicationController

    def create
        new_transaction = Transaction.create!(trans_params)
        render json: new_transaction, status: :created
    end

    def index  
        render json: Transaction.all
    end




    def spend
        x = spend_params[:points]
        spend_array = []  #link this methed to the user_id
            trans_by_date = Transaction.all.sort_by do |trans| trans.created_at
            end
        until x == 0
            trans_by_date.each do |trans| 
                x - trans.points  
                
                if trans.points > 0
                    spend_array.push(Payer.find_by_id(trans.payer_id).partner, -(trans.points))
                end
            end
        end
        
        render json: spend_array

    end

    def spend_params
        params.permit(:points)
    end

    def trans_params
        params.permit(:payer_id, :points, :user_id)
    end
    
end
