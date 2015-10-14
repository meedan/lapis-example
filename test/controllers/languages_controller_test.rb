require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'test_helper')

class LanguagesControllerTest < ActionController::TestCase
  def setup
    super
    @controller = Api::V1::LanguagesController.new
  end

  test "should get language" do
    authenticate_with_token
    get :classify, text: 'This is a test'
    assert_response :success
    assert_equal :english, assigns(:language)
  end

  test "should return error if text was not provided" do
    authenticate_with_token
    get :classify
    assert_response 400
  end
end
