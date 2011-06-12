require 'test_helper'

class PolicyMarkersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:policy_markers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create policy_marker" do
    assert_difference('PolicyMarker.count') do
      post :create, :policy_marker => { }
    end

    assert_redirected_to policy_marker_path(assigns(:policy_marker))
  end

  test "should show policy_marker" do
    get :show, :id => policy_markers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => policy_markers(:one).to_param
    assert_response :success
  end

  test "should update policy_marker" do
    put :update, :id => policy_markers(:one).to_param, :policy_marker => { }
    assert_redirected_to policy_marker_path(assigns(:policy_marker))
  end

  test "should destroy policy_marker" do
    assert_difference('PolicyMarker.count', -1) do
      delete :destroy, :id => policy_markers(:one).to_param
    end

    assert_redirected_to policy_markers_path
  end
end
