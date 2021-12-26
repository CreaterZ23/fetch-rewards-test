class SpendController < ApplicationController


    def spend 

        # Initialize algoritm
        payers = Payer.all
        hash ={}
        payers.each do |payer|
            hash[payer.payer_name] = {spent: payer.amount_spent, balance: payer.balance, charged: 0}
        end
        
        points_to_spend = spend_params[:amount]
    
        # get transactions from oldest to newest
        ordered_transactions = Transaction.all.sort_by do |tran| tran.timestamp
        end
        
        # process spend
        for transaction in ordered_transactions
    
            payer = hash[transaction.payer_name]
            transaction_points = transaction.points
            
            # positive transaction
            if transaction_points >= 0
                
                if payer[:spent] < 0

                    payer[:spent] = payer[:spent] - transaction_points
                    next
    
                end
                
                amount_spent_diff = payer[:spent] - transaction_points
                
                if amount_spent_diff > 0
                    
                    payer[:spent] = amount_spent_diff
    
                else
    
                    payer[:spent] = 0
                    # byebug
                    if payer[:balance] > points_to_spend
    
                        remaining_points = points_to_spend - transaction_points
    
                        if remaining_points > 0
    
                            payer[:balance] = payer[:balance] - transaction_points
                            payer[:charged] = payer[:charged] + transaction_points
                            points_to_spend = points_to_spend - transaction_points
    
                        else
    
                            payer[:balance] = payer[:balance] - points_to_spend
                            payer[:charged] = payer[:charged] + points_to_spend
                            payer[:spent] = payer[:spent] + remaining_points
                            points_to_spend = 0
    
    
                        end
    
                    else
    
                        remaining_points = payer[:balance] - transaction_points
    
                        if remaining_points > 0
    
                            payer[:balance] = payer[:balance] - transaction_points
                            payer[:charged] = payer[:charged] + transaction_points
                            points_to_spend = points_to_spend - transaction_points
    
                        else
    
                            payer[:charged] = payer[:charged] + payer[:balance]
                            payer[:spent] = payer[:spent] + remaining_points
                            points_to_spend = points_to_spend - payer[:balance]
                            payer[:balance] = 0
    
                        end
    
                    end
    
                end
    
            # negative transaction
            else
    
                if payer[:spent] < 0
    
                    remaining_points = payer[:spent] - transaction_points
    
                    if remaining_points > 0
    
                        payer[:spent] = 0
                        transaction_points = -remaining_points
    
                    else
    
                        payer[:spent] = remaining_points
                        next
    
                    end 
                end
    
                remaining_points = payer[:charged] + transaction_points
    
                if remaining_points > 0
    
                    payer[:charged] = remaining_points
                    payer[:balance] = payer[:balance] - transaction_points
                    points_to_spend = points_to_spend - transaction_points
    
                else
    
                    payer[:balance] = payer[:balance] + payer[:charged]
                    points_to_spend = points_to_spend + payer[:charged]
                    payer[:charged] = 0
                    payer[:spent] = payer[:spent] - transaction_points
    
                end
            end
        end
    
        # Finished Processing spend, update balances & return json response
        if points_to_spend > 0
    
            Throw Exception. Insufficient balance
        else
            returnHash = {}
    
            payers.each do |payer|
    
                if hash[payer.payer_name][:charged] > 0
                    returnHash[payer.payer_name] = - hash[payer.payer_name][:charged]
                    new_balance = payer[:balance] - hash[payer.payer_name][:charged]
                    new_amount_spent = payer[:amount_spent] + hash[payer.payer_name][:charged]
                    payer.update(balance: new_balance)
                    payer.update(amount_spent: new_amount_spent)
                end
            end
    
            render json: returnHash
        end
    end




    def spend_params
        params.permit(:amount, :user_id)
    end
end
