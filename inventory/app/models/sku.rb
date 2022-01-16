class Sku < ApplicationRecord
	include ActiveModel::Serializers::JSON

	validates :token, :description, :quantity, :price_cents, presence: true

	def as_json(options={})
		options[:except] ||= [:id]
		super(options)
	end

end
