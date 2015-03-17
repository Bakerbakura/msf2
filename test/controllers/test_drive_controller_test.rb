require 'test_helper'

class TestDriveControllerTest < ActionController::TestCase
  test "should get start" do
    get :start
    assert_response :success
  end

  test "should get addshoes" do
    get :addshoes
    assert_response :success
  end

  test "should get request" do
    get :request
    assert_response :success
  end

  test "should get prediction" do
    get :prediction
    assert_response :success
  end

end
