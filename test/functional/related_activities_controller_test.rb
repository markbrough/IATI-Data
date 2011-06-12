require 'test_helper'

class RelatedActivitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:related_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create related_activity" do
    assert_difference('RelatedActivity.count') do
      post :create, :related_activity => { }
    end

    assert_redirected_to related_activity_path(assigns(:related_activity))
  end

  test "should show related_activity" do
    get :show, :id => related_activities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => related_activities(:one).to_param
    assert_response :success
  end

  test "should update related_activity" do
    put :update, :id => related_activities(:one).to_param, :related_activity => { }
    assert_redirected_to related_activity_path(assigns(:related_activity))
  end

  test "should destroy related_activity" do
    assert_difference('RelatedActivity.count', -1) do
      delete :destroy, :id => related_activities(:one).to_param
    end

    assert_redirected_to related_activities_path
  end
end
