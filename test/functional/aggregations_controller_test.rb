require 'test_helper'

class AggregationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:aggregations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create aggregation" do
    assert_difference('Aggregation.count') do
      post :create, :aggregation => { }
    end

    assert_redirected_to aggregation_path(assigns(:aggregation))
  end

  test "should show aggregation" do
    get :show, :id => aggregations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => aggregations(:one).to_param
    assert_response :success
  end

  test "should update aggregation" do
    put :update, :id => aggregations(:one).to_param, :aggregation => { }
    assert_redirected_to aggregation_path(assigns(:aggregation))
  end

  test "should destroy aggregation" do
    assert_difference('Aggregation.count', -1) do
      delete :destroy, :id => aggregations(:one).to_param
    end

    assert_redirected_to aggregations_path
  end
end
