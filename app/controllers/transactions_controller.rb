class TransactionsController < ApplicationController

    def create
        
        payer = Payer.find_by(payer_name: trans_params[:payer_name])
        if payer.nil?
            payer = create_new_payer(trans_params)
        end
        # byebug
        new_balance = payer.balance + trans_params[:points]
        if new_balance < 0     
        # do exceptions here
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

    


    def spend
        x = spend_params[:points]
        spend_array = []  #link this methed to the user_id
            trans_by_date = Transaction.all.sort_by do |trans| trans.created_at
            end
        until x == 0
            trans_by_date.each do |trans| 
                x = x - trans.points  
                #x = 300 - 1000
                #if x > trans.points
                    #x = x - trans.points
                #
        
                # if trans.points > 0
                #     spend_array.push(Payer.find_by_id(trans.payer_id).partner, -(trans.points))
                # end
            end
        end
        byebug 
        #render json: spend_array
    end

    def spend_params
        params.permit(:points)
    end

    def trans_params
        params.permit(:payer_name, :points, :user_id, :timestamp)
    end
    
end

#{ "payer": "DANNON", "points": 300, "timestamp": "2020-10-31T10:00:00Z" }
#{ "payer": "UNILEVER", "points": 200, "timestamp": "2020-10-31T11:00:00Z" }
#{ "payer": "DANNON", "points": -200, "timestamp": "2020-10-31T15:00:00Z" }
#  "payer": "MILLER COORS", "points": 10000, "timestamp": "2020-11-01T14:00:00Z" }
#{ "payer": "DANNON", "points": 1000, "timestamp": "2020-11-02T14:00:00Z" }