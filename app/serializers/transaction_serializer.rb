class TransactionSerializer < ActiveModel::Serializer
  attributes :points, :payer
  

  def payer
    Payer.find_by_id(self.object.payer_id).partner
  end
end
