class PayerSerializer < ActiveModel::Serializer
  attributes :id, :payer_name, :balance, :amount_spent
end
