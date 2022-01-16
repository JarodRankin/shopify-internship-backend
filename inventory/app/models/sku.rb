class Sku < ApplicationRecord
	include ActiveModel::Serializers::JSON

	validates :token, :description, :quantity, :price_cents, presence: true

end
