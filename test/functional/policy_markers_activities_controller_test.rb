require 'test_helper'

class PolicyMarkersActivitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:policy_markers_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create policy_markers_activity" do
    assert_difference('PolicyMarkersActivity.count') do
      post :create, :policy_markers_activity => { }
    end

    assert_redirected_to policy_markers_activity_path(assigns(:policy_markers_activity))
  end

  test "should show policy_markers_activity" do
    get :show, :id => policy_markers_activities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => policy_markers_activities(:one).to_param
    assert_response :success
  end

  test "should update policy_markers_activity" do
    put :update, :id => policy_markers_activities(:one).to_param, :policy_markers_activity => { }
    assert_redirected_to policy_markers_activity_path(assigns(:policy_markers_activity))
  end

  test "should destroy policy_markers_activity" do
    assert_difference('PolicyMarkersActivity.count', -1) do
      delete :destroy, :id => policy_markers_activities(:one).to_param
    end

    assert_redirected_to policy_markers_activities_path
  end
end
