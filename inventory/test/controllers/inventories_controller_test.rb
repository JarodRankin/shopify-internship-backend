require "test_helper"
require 'active_support/core_ext/hash'

class InventoryControllerTest < ActionDispatch::IntegrationTest

  setup do
    @sku = skus(:samsung_phone)
  end

  test "should create sku" do

    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

      assert_equal 200, status

      #Equate without timestamps
      response_sku = sku_with_timestamps_removed(JSON.parse(response.body))
      assert_equal response_sku, mock_sku[:sku].stringify_keys

  end

  test "should create sku with auto assigned token" do

    mock_sku = {
      sku: {
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku",
      params: { sku: mock_sku[:sku] }

      assert_equal 200, status

      #Equate without timestamps
      response_sku = sku_with_timestamps_removed(JSON.parse(response.body))
      assert response_sku["token"].present?
      response_sku.delete("token")
      assert_equal response_sku, mock_sku[:sku].stringify_keys

  end

  test "create sku should fail with error bad request" do

    expected_error = {
      message: "Missing parameter \"sku\"",
      status: "bad_request"
    }

    post "/inventory/sku",
      params: { }

      assert_equal 400, status

      response_error = JSON.parse(response.body)

      assert_equal expected_error.stringify_keys, response_error

  end

  test "find sku" do

    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

    get "/inventory/sku",
      params:{token: "abcd"}
      
      #Equate without timestamps
      response_sku = sku_with_timestamps_removed(JSON.parse(response.body))
      assert_equal response_sku, mock_sku[:sku].stringify_keys
  end

  test "find sku should fail with error bad request" do
      expected_error = {
      message: "Sku not found",
      status: "bad_request"
    }
    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

    get "/inventory/sku",
      params:{token: "abef"}

      response_error = JSON.parse(response.body)

      assert_equal expected_error.stringify_keys, response_error

  end

  test "delete sku test" do

    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

    delete "/inventory/sku",
      params:{token: "abcd"}

      assert_equal 204, status
  end

  test "delete sku test expect bad request error" do

    expected_error = {
      message: "Sku not found for provided token\"",
      status: "bad_request"
    }

    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

    delete "/inventory/sku",
      params:{token: "abef"}

      assert_equal 400, status

      response_error = JSON.parse(response.body)

      assert_equal expected_error.stringify_keys, response_error
  end

  test "undo delete sku test" do

    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

    delete "/inventory/sku",
      params:{token: "abcd"}

    post '/inventory/sku/recover',
      params:{token: "abcd"}

      response_sku = sku_with_timestamps_removed(JSON.parse(response.body))
      assert_equal response_sku, mock_sku[:sku].stringify_keys
  end

  test "undo delete sku test with exepected bad request error" do

    expected_error = {
      message: "Sku not found for provided token\"",
      status: "bad_request"
    }

    mock_sku = {
      sku: {
        token: "abcd",
        description: "a yellow samsung phone",
        quantity: 10,
        price_cents: 1000
      }
    }

    post "/inventory/sku", 
      params: { sku: mock_sku[:sku] }

    delete "/inventory/sku",
      params:{token: "abcd"}

    post '/inventory/sku/recover',
      params:{token: "abef"}

      assert_equal 400, status

      response_error = JSON.parse(response.body)

      assert_equal expected_error.stringify_keys, response_error
  end

  private 

  def sku_with_timestamps_removed(sku)
    sku.delete("created_at")
    sku.delete("updated_at")
    sku
  end

end
