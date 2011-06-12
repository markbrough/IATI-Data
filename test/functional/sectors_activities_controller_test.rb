require 'test_helper'

class SectorsActivitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sectors_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sectors_activity" do
    assert_difference('SectorsActivity.count') do
      post :create, :sectors_activity => { }
    end

    assert_redirected_to sectors_activity_path(assigns(:sectors_activity))
  end

  test "should show sectors_activity" do
    get :show, :id => sectors_activities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sectors_activities(:one).to_param
    assert_response :success
  end

  test "should update sectors_activity" do
    put :update, :id => sectors_activities(:one).to_param, :sectors_activity => { }
    assert_redirected_to sectors_activity_path(assigns(:sectors_activity))
  end

  test "should destroy sectors_activity" do
    assert_difference('SectorsActivity.count', -1) do
      delete :destroy, :id => sectors_activities(:one).to_param
    end

    assert_redirected_to sectors_activities_path
  end
end
