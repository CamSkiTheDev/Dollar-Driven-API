require "test_helper"

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @property = properties(:one)
  end

  test "should get index" do
    get properties_url, as: :json
    assert_response :success
  end

  test "should create property" do
    assert_difference('Property.count') do
      post properties_url, params: { property: { after_repair_value: @property.after_repair_value, estimated_rent: @property.estimated_rent, estimated_value: @property.estimated_value, street_adderss: @property.street_adderss, user_id: @property.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show property" do
    get property_url(@property), as: :json
    assert_response :success
  end

  test "should update property" do
    patch property_url(@property), params: { property: { after_repair_value: @property.after_repair_value, estimated_rent: @property.estimated_rent, estimated_value: @property.estimated_value, street_adderss: @property.street_adderss, user_id: @property.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy property" do
    assert_difference('Property.count', -1) do
      delete property_url(@property), as: :json
    end

    assert_response 204
  end
end
