require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get docs" do
    get pages_docs_url
    assert_response :success
  end
end
