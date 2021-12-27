class SpendController < ApplicationController


    def spend 

        points_to_spend = spend_params[:points]

        if points_to_spend.nil?
            render json: {error: "No points Were Given"}
        end

        # Initialize algoritm
        payers = Payer.all
        hash ={}
        payers.each do |payer|
            hash[payer.payer_name] = {spent: payer.amount_spent, balance: payer.balance, charged: 0}
        end
    
        # get transactions from oldest to newest
        ordered_transactions = Transaction.all.sort_by do |tran| tran.timestamp
        end
        
        # process spend
        for transaction in ordered_transactions
    
            
            transaction_points = transaction.points
            
            # positive transaction
            if transaction_points >= 0 
                #checks to see if payer has previous spent points
                if hash[transaction.payer_name][:spent] < 0 
                    #compesates for previous positive transactions
                    hash[transaction.payer_name][:spent] = hash[transaction.payer_name][:spent] - transaction_points
                    next
    
                end
                
                amount_spent_diff = hash[transaction.payer_name][:spent] - transaction_points
                #logic for if all the points from transaction has already been spent
                if amount_spent_diff > 0
                    
                    hash[transaction.payer_name][:spent] = amount_spent_diff
    
                else
                    
                    hash[transaction.payer_name][:spent] = 0
                    transaction_points = -amount_spent_diff
                    #logic to take points from a hash[transaction.payer_name] with enough points in their balance to satisfy the rest of the spend points
                    if hash[transaction.payer_name][:balance] > points_to_spend
    
                        remaining_points = points_to_spend - transaction_points
                        #logic for setting the values if there are remaining points
                        if remaining_points > 0
    
                            hash[transaction.payer_name][:balance] = hash[transaction.payer_name][:balance] - transaction_points
                            hash[transaction.payer_name][:charged] = hash[transaction.payer_name][:charged] + transaction_points
                            points_to_spend = points_to_spend - transaction_points
                        #logic for setting the values if there are no remaining points
                        else
    
                            hash[transaction.payer_name][:balance] = hash[transaction.payer_name][:balance] - points_to_spend
                            hash[transaction.payer_name][:charged] = hash[transaction.payer_name][:charged] + points_to_spend
                            hash[transaction.payer_name][:spent] = hash[transaction.payer_name][:spent] + remaining_points 
                            points_to_spend = 0
    
    
                        end
                    #logic for if the payer has points but not enough to cover the spend points completely
                    else
                        
                        remaining_points = hash[transaction.payer_name][:balance] - transaction_points
    
                        if remaining_points > 0
    
                            hash[transaction.payer_name][:balance] = hash[transaction.payer_name][:balance] - transaction_points
                            hash[transaction.payer_name][:charged] = hash[transaction.payer_name][:charged] + transaction_points
                            points_to_spend = points_to_spend - transaction_points
    
                        else
    
                            hash[transaction.payer_name][:charged] = hash[transaction.payer_name][:charged] + hash[transaction.payer_name][:balance]
                            hash[transaction.payer_name][:spent] = hash[transaction.payer_name][:spent] + remaining_points
                            points_to_spend = points_to_spend - hash[transaction.payer_name][:balance]
                            hash[transaction.payer_name][:balance] = 0
    
                        end
    
                    end
    
                end
    
            # negative transaction
            else
                #this is accounting for previous positive transactions 
                if hash[transaction.payer_name][:spent] < 0
    
                    remaining_points = hash[transaction.payer_name][:spent] - transaction_points
                    
                    if remaining_points > 0
    
                        hash[transaction.payer_name][:spent] = 0
                        transaction_points = -remaining_points
    
                    else
    
                        hash[transaction.payer_name][:spent] = remaining_points
                        next
    
                    end 
                end
    
                remaining_points = hash[transaction.payer_name][:charged] + transaction_points
                
                if remaining_points > 0
    
                    hash[transaction.payer_name][:charged] = remaining_points
                    hash[transaction.payer_name][:balance] = hash[transaction.payer_name][:balance] - transaction_points
                    points_to_spend = points_to_spend - transaction_points
    
                else
    
                    hash[transaction.payer_name][:balance] = hash[transaction.payer_name][:balance] + hash[transaction.payer_name][:charged]
                    points_to_spend = points_to_spend + hash[transaction.payer_name][:charged]
                    hash[transaction.payer_name][:charged] = 0
                    hash[transaction.payer_name][:spent] = hash[transaction.payer_name][:spent] - transaction_points
    
                end
            end
        end
    
        # Finished Processing spend, update balances & return json response
        if points_to_spend > 0
    
            render json: { error: 'Insufficient balance'}
        
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
        params.permit(:points)
    end
end
