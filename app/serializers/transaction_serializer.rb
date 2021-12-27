class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :points, :payer_name, :timestamp
  
end
