require 'test_helper'

class MattersControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @matter = matters(:one)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_matter = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    sign_in users(:one)
    get matters_url#, headers: @auth_h_matter
    assert_response :success
  end

  test "should get new" do
    sign_in users(:one)
    get new_matter_url#, headers: @auth_h_matter
    assert_response :success
    sign_out :user
  end

  test "should create matter" do
    sign_in users(:one)
    assert_difference('Matter.count') do
      post matters_url, params: { matter: { description: @matter.description, enable: @matter.enable, name: @matter.name, trayect: @matter.trayect } }
    end

    assert_redirected_to matter_url(Matter.last)
    sign_out :user
  end

  test "should show matter" do
    sign_in users(:one)
    get matter_url(@matter)#, headers: @auth_h_matter
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_matter_url(@matter)#, headers: @auth_h_matter
    assert_response :success
    sign_out :user
  end

  test "should update matter" do
    sign_in users(:one)
    patch matter_url(@matter), params: { matter: { description: @matter.description, enable: @matter.enable, name: @matter.name } }
    assert_redirected_to matter_url(@matter)
    sign_out :user
  end

  test "should destroy matter" do
    sign_in users(:one)
    assert_difference('Matter.count', -1) do
      delete matter_url(@matter)#, headers: @auth_h_matter
    end

    assert_response :found
    sign_out :user
  end
end
