require 'uuidtools'

class InventoryController < ActionController::Base
	
	# return a list of all sku's
	# @return [Sku]
	def all
		skus = Sku.all
		render json: skus
	end

	# returns a unique sku by token
	# @parameter :token => String
	# @return Sku
	def find_sku
		sku = sku_with_token(params[:token])

		if sku && sku.valid?
			render json: sku
		else
			head :no_content
		end

	end

	# Creates a new sku and assigns it a unique token if one is not
	# provided.
	# @parameter :sku => JSON Representation of a Sku
	# @return Sku
	def new_sku
		sku_json = params[:sku]

		# Check if the sku parameter is provided
		if !sku_json then
			# TODO: - Render error
			head :bad_request
			return
		end

		# Pull the optional paramter token out of params
		token = sku_json[:token]

		# Check if token was provided, if not set to random UUID prefix
		if !token then token = token = UUIDTools::UUID.timestamp_create.to_s[0..7] end
		
		# Try to find an existing Sku with the same token prior to creating
		if sku_with_token(token) then
			# TODO: - Render error
			head :bad_request
			return
		end

		# TODO: - Figure out why I cant create a Sku with the hash in params
		sku = Sku.create(:token => token, :description => sku_json[:description], :price_cents => sku_json[:price_cents], :quantity => sku_json[:quantity])

		render json: sku
	end

	def update_sku
		sku_json = params[:sku]
		token = sku_json[:token]

		if !token then
			# TODO: - Render error
			head :bad_request
			return
		end

		sku_to_update = sku_with_token(token)

		if !sku_to_update then
			# TODO: - Render error
			head :bad_request
			return
		end

		# TODO: - Figure out why I cant create a Sku with the hash in params
		sku_to_update.update(
			:description => sku_json[:description] ? sku_json[:description] : sku_to_update.description , 
			:price_cents => sku_json[:price_cents] ? sku_json[:price_cents] : sku_to_update.price_cents, 
			:quantity => sku_json[:quantity] ? sku_json[:quantity] : sku_to_update.quantity
		)

		render json: sku_to_update
	end


	private

	# returns a unique sku by token
	# @return Sku
	def sku_with_token(token)
		Sku.find_by(token: token)
	end

end
