require File.expand_path('../../test_helper', __FILE__)
class PollsControllerTest < ActionController::TestCase
  fixtures :projects

  def test_index
@request.session[:user_id] = 2
    get :index, params: { project_id: 1 }

    assert_response :success
  end
end
