class ListSerializer < ActiveModel::Serializer
  attributes :name, :permissions

  has_many :items
end
