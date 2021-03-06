require 'test_helper'

class CommissionsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @commission = commissions(:incoming)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_commission = Devise::JWT::TestHelpers.auth_headers(headers, users(:user_test_full_access))
  end

  test "should get index" do
    sign_in users(:user_test_full_access)
    get commissions_url#, headers: @auth_h_commission
    assert_response :success
    sign_out :user
  end

  test "should get index_unlogged" do
    sign_in users(:user_test_full_access)
    get commissions_url
    assert_response :success
    sign_out :user
  end

  test "should get new" do
    sign_in users(:user_test_full_access)
    get commissions_url#, headers: @auth_h_commission
    assert_response :success
    sign_out :user
  end

  test "should get new_unlogged" do
    sign_in users(:user_test_full_access)
    get new_commission_url
    assert_response :success
    sign_out :user
  end

  test "should create commission" do
    sign_in users(:user_test_full_access)
    assert_difference('Commission.count') do
      post commissions_url,
        params: {
          commission: {
            description: "Descripcion de prueba para la comision",
            end_date: Time.rfc3339('2032-12-31T14:00:00-10:00'),
            name: "Una comision",
            start_date: Time.rfc3339('2031-12-31T14:00:00-10:00')
            }
          }
      end
    com=Commission.last
    assert_redirected_to time_sheets_associate_path commission_id: com.id.to_s, commission_name: com.name, notice: 'Commission was successfully created.'
    sign_out :user
  end

  test "should show commission" do
    sign_in users(:user_test_full_access)
    get commission_url(@commission)#, headers: @auth_h_commission
    assert_response :success
    sign_out :user
  end

  test "should get edit" do
    sign_in users(:user_test_full_access)
    @commission.description="A second commission"
    @commission.end_date=Time.rfc3339('2032-12-31T14:00:00-10:00')
    @commission.name="Commission two"
    @commission.start_date=Time.rfc3339('2031-12-31T14:00:00-10:00')

    get commission_url(@commission)#, headers: @auth_h_commission
    assert_response :success
    get "/commissions#edit" #, headers: @auth_h_commission
    assert_response :success
    sign_out :user
  end

  test "should update commission" do
    sign_in users(:user_test_full_access)
    patch commission_url(@commission),
      params: {
          commission: {
            description: @commission.description,
            end_date: @commission.end_date,
            name: @commission.name,
            start_date: Time.now
            }
          }
    sign_out :user
  end

  test "should destroy commission" do
    sign_in users(:user_test_full_access)
    @commission.description="A second commission"
    @commission.end_date=Time.rfc3339('2032-12-31T14:00:00-10:00')
    @commission.name="Commission two"
    @commission.start_date=Time.rfc3339('2031-12-31T14:00:00-10:00')
    @commission.save

    c1=Usercommissionrole.joins(:commission).find_by(commission: @commission).destroy
    assert_difference('Commission.count', -1) do
      delete commission_url(@commission)#, headers: @auth_h_commission
    end

    assert_response :found
    sign_out :user
  end
end
