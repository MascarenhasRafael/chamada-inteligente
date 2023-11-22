require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @professor_email = 'professor@ic.uff.br'
    @professor_password = 'professor'
    @invalid_password = 'invalid_password'
    @auth_type = :professor
    @valid_auth_token = 'example_token'
    @expired_auth_token = 'expired_token'
  end

  teardown do
    Access.destroy_all
  end

  test 'should retrive session with a stored valid token' do
    Access.create!(
      user_token: @valid_auth_token,
      user_email: @professor_email,
      auth_type: @auth_type,
      expires_at: 1.day.from_now
    )

    post login_url, params: { auth_token: @valid_auth_token }
    
    assert_response :success
    assert_equal 'Login successful', json_response['message']
    assert_not_nil json_response['token']
  end

  test 'should create session with valid email, password, and auth_type (without token)' do
    post login_url, params: { email: @professor_email, password: @professor_password, auth_type: @auth_type }
    
    assert_response :success
    assert_equal 'Login successful', json_response['message']
    assert_not_nil json_response['token']
  end

  test 'should return bad request if missing required parameters' do
    post login_url, params: { password: @professor_password, auth_type: @auth_type }
    
    assert_response :bad_request
  end

  test 'should return unauthorized on invalid password' do
    post login_url, params: { email: @professor_email, password: @invalid_password, auth_type: @auth_type }
    
    assert_response :unauthorized
    assert_equal 'Invalid credentials', json_response['error']
  end

  test 'should return unauthorized on expired token' do
    Access.create!(
      user_email: @professor_email,
      user_token: @expired_auth_token,
      auth_type: @auth_type,
      expires_at: 1.hour.ago
    )

    post login_url, params: { auth_token: @expired_auth_token }
    
    assert_response :unauthorized
    assert_equal 'Invalid credentials', json_response['error']
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
