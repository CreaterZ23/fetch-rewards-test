class SpendController < ApplicationController


    def spend 
        payers = Payer.all
        hash ={}
        payers.each do |payer|
            hash[payer.payer_name] = {spent: payer.amount_spent, balance: payer.balance, charged: 0}
        end
        points_to_spend = spend_params[:amount]
        ordered_transactions = Transaction.all.sort_by do |tran| tran.timestamp
        end
        for transaction in ordered_transactions
            if transaction.points >=0
                                    #positive tran
            else

            end
        end
    end

    


    def spend_params
        params.permit(:amount, :user_id)
    end
end
