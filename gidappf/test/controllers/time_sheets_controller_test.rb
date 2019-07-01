require 'test_helper'

class TimeSheetsControllerTest < ActionDispatch::IntegrationTest
  # Libreria que provee de la autenticacion
  include Devise::Test::IntegrationHelpers

  setup do
    @time_sheet = time_sheets(:one)
    # headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # @auth_h_ts = Devise::JWT::TestHelpers.auth_headers(headers, users(:one))
  end

  test "should get index" do
    sign_in users(:one)
    get time_sheets_url#, headers: @auth_h_ts
    assert_response :success
    sign_out :one
  end

  test "should show time_sheet_hour" do
    sign_in users(:one)
    get time_sheet_url(@time_sheet)#, headers: @auth_h_ts
    assert_response :success
    sign_out :one
  end

  test "should get associate" do
    sign_in users(:one)
    get time_sheets_associate_url#, headers: @auth_h_ts
    assert_response :found
    sign_out :one
  end

  test "should update time_sheet" do
    sign_in users(:one)
    patch time_sheet_url(@time_sheet),
      params: {
        time_sheet: {
          start_date: 1.month.after,
          end_date: 1.year.after,
          enabled: true
          } }
    assert_redirected_to time_sheet_url(@time_sheet)
    sign_out :one
  end

  test "should destroy time_sheet" do
    sign_in users(:one)
    assert_difference('TimeSheetHour.count', -1) do
      delete time_sheet_url(@time_sheet)#, headers: @auth_h_ts
    end

    assert_response :found
    sign_out :one
  end

end
