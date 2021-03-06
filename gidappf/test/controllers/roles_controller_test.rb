require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @role = roles(:anyrole)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_role = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get index" do
    sign_in users(:user_test_full_access)
    get roles_url#, headers: @auth_h_role
    assert_response :success
    sign_out :user
  end

  test "should get index_unlogged" do
    # sign_in users(:user_test_full_access)
    get roles_url
    assert_response :found
    # sign_out :user
  end

  test "should get new" do
    sign_in users(:user_test_full_access)
    get roles_url #, headers: @auth_h_role
    assert_response :success
    sign_out :user
  end

  test "should get new_unlogged" do
    sign_in users(:user_test_full_access)
    get new_role_url
    assert_response :success
    sign_out :user
  end

  test "should create role" do
    sign_in users(:user_test_full_access)
    assert_difference('Role.count') do
      post roles_url,
        params: { role: {
                    created_at: Time.now,
                    description: 'una descripcion larga de varias palabras',
                    enabled: true,
                    name: 'un nombre' }
                  }
    end
      assert_redirected_to role_url(Role.last)
      sign_out :user
    end

  test "should show role" do
    sign_in users(:user_test_full_access)
    get role_url(@role)#, headers: @auth_h_role
    assert_response :success
    sign_out :user
  end

  test "should show role_unlogged" do
    sign_in users(:user_test_full_access)
    get role_url(@role)
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:user_test_full_access)
    get role_url(@role)#, headers: @auth_h_role
    assert_response :success
    get "/roles#edit" #, headers: @auth_h_role
    assert_response :success
    sign_out :user
  end

  test "should get edit_unlogged" do
    # sign_in users(:user_test_full_access)
    get edit_role_url(@role)
    assert_response :found
    # sign_out :user
  end

  test "should update role" do
    sign_in users(:user_test_full_access)
    patch role_url(@role),
      #headers: @auth_h_role),
      params: {
        role: {
          created_at: Time.rfc3339('1999-12-31T14:00:00-10:00'),
          description: 'Otra descripcion de varias palabras',
          enabled: true,
          name: 'Otro nombre lindo'
        }
      }
    assert_redirected_to  role_url(@role) #, headers: @auth_h_role
    sign_out :user
  end

  test "should destroy role" do
    sign_in users(:user_test_full_access)
    @role.created_at= Time.rfc3339('1999-12-31T14:00:00-10:00')
    @role.description= 'Otra descripcion de varias palabras'
    @role.enabled= true
    @role.name= 'Otro nombre lindo'
    r1=Usercommissionrole.joins(:role).find_by(role: @role).destroy
    assert_difference('Role.count', -1) do
      delete role_url(@role)#, headers: @auth_h_role
    end
    assert_response :found
    sign_out :user
  end
end
