require 'uuidtools'

class InventoryController < ApplicationController

	before_action :populate_sku_and_optional_token, only: [:new_sku]
	before_action :populate_sku_and_token, only: [:update_sku]
	before_action :populate_token_param, only: [:find_sku, :delete_sku, :undo_delete]
	
	def all
		skus = Sku.all
		render json: skus
	end

	def find_sku
		sku = sku_with_token(@token)

		if sku
			render json: sku
		else
			render json: Error.new('Sku not found', :bad_request), :status => :bad_request
		end

	end

	def new_sku

		if !@sku then
			return
		else

			@token = @token || UUIDTools::UUID.timestamp_create.to_s[0..7]

			if sku_with_token(@token)
				render json: Error.new('Sku already exists for provided token', :bad_request), :status => :bad_request
			else
				# TODO: - Figure out why I cant create a Sku with the hash in params
				sku = Sku.create(
					:token => @token,
					:description => @sku[:description],
					:price_cents => @sku[:price_cents],
					:quantity => @sku[:quantity]
				)
				if !sku.valid?
					render json: Error.new('Invalid Sku provided', :bad_request), :status => :bad_request
				else
					render json: sku
				end
			end

		end

	end

	def update_sku

		if !@token then return end

		sku_to_update = sku_with_token(@token)

		if !sku_to_update
			render json: Error.new('Sku not found for provided token"', :bad_request), :status => :bad_request
			return
		end

		# TODO: - Figure out why I cant create a Sku with the hash in params
		result = sku_to_update.update(
			:description => @sku[:description] || sku_to_update.description , 
			:price_cents => @sku[:price_cents] || sku_to_update.price_cents, 
			:quantity => @sku[:quantity] || sku_to_update.quantity
		)

		render json: sku_to_update
	end

	def delete_sku

		if !@token
			return
		end

		sku_to_delete = sku_with_token(@token)

		if !sku_to_delete
			render json: Error.new('Sku not found for provided token"', :bad_request), :status => :bad_request
		else

			sku = Deleted.create(
				:token => sku_to_delete.token,
				:description => sku_to_delete.description,
				:price_cents => sku_to_delete.price_cents,
				:quantity => sku_to_delete.quantity
			)

			sku_to_delete.delete()
		end

	end


	def undo_delete

		if !@token
			return
		end

		sku_to_update = sku_with_token(@token)

		if !sku_to_update
			render json: Error.new('Sku not found for provided token"', :bad_request), :status => :bad_request
			return
		end

		sku = Sku.create(
			:token => token,
			:description => sku_json[:description],
			:price_cents => sku_json[:price_cents],
			:quantity => sku_json[:quantity]
		)
		render json: sku

	end

	private

	def sku_with_token(token)
		Sku.find_by(token: token)
	end

	def populate_sku_and_optional_token
		@sku = params[:sku]
		if !@sku
			render json: Error.new('Missing parameter "sku"', :bad_request), :status => :bad_request
			return
		end
		@token = @sku[:token]
	end

	def populate_token_param
		@token = params[:token]
		if !@token
			render json: Error.new('Missing parameter "token"', :bad_request), :status => :bad_request
		end
	end

	def populate_sku_and_token
		populate_sku_and_optional_token()
		if !@token
			render json: Error.new('Missing parameter "token"', :bad_request), :status => :bad_request
		end
	end

end
