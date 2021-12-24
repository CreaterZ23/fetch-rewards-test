class BalanceController < ApplicationController
    def balance
        hash = {}
        Payer.all.each do |payer|
            hash[payer.payer_name] = payer.balance
            # render json: {payer_name: payer.payer_name, balance: payer.balance}
        end
        render json: hash
    end
end
