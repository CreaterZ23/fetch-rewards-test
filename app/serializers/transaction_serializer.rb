class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :points, :payer_name, :timestamp
  

  # def payer
  #   Payer.find_by_id(self.object.payer_id).partner
  # end
end
