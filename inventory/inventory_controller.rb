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

		puts "1\n"

		# Check if the sku parameter is provided
		if !sku_json then head :bad_request end

		puts "2\n"

		# Pull the optional paramter token out of params
		token = sku_json[:token]

		puts "3\n"

		# Check if token was provided, if not set to random UUID prefix
		if !token then token = token = UUIDTools::UUID.timestamp_create.to_s[0..7] end
		
		puts "4\n"

		# Try to find an existing Sku with the same token prior to creating
		if sku_with_token(token) then head :bad_request end
	end

	private

	# returns a unique sku by token
	# @return Sku
	def sku_with_token
		Sku.find_by(token: token)
	end

end
