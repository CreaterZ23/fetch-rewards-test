class BalanceController < ApplicationController
    def balance
        hash = {}
        Payer.all.each do |payer|
            hash[payer.payer_name] = payer.balance
        end
        render json: hash
    end
end
