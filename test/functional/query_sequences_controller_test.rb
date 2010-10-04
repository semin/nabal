require 'test_helper'

class QuerySequencesControllerTest < ActionController::TestCase
  setup do
    @query_sequence = query_sequences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:query_sequences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create query_sequence" do
    assert_difference('QuerySequence.count') do
      post :create, :query_sequence => @query_sequence.attributes
    end

    assert_redirected_to query_sequence_path(assigns(:query_sequence))
  end

  test "should show query_sequence" do
    get :show, :id => @query_sequence.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @query_sequence.to_param
    assert_response :success
  end

  test "should update query_sequence" do
    put :update, :id => @query_sequence.to_param, :query_sequence => @query_sequence.attributes
    assert_redirected_to query_sequence_path(assigns(:query_sequence))
  end

  test "should destroy query_sequence" do
    assert_difference('QuerySequence.count', -1) do
      delete :destroy, :id => @query_sequence.to_param
    end

    assert_redirected_to query_sequences_path
  end
end
