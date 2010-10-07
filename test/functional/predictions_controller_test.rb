require 'test_helper'

class PredictionsControllerTest < ActionController::TestCase
  setup do
    @prediction = predictions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:predictions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prediction" do
    assert_difference('Prediction.count') do
      post :create, :prediction => @prediction.attributes
    end

    assert_redirected_to prediction_path(assigns(:prediction))
  end

  test "should show prediction" do
    get :show, :id => @prediction.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @prediction.to_param
    assert_response :success
  end

  test "should update prediction" do
    put :update, :id => @prediction.to_param, :prediction => @prediction.attributes
    assert_redirected_to prediction_path(assigns(:prediction))
  end

  test "should destroy prediction" do
    assert_difference('Prediction.count', -1) do
      delete :destroy, :id => @prediction.to_param
    end

    assert_redirected_to predictions_path
  end
end
