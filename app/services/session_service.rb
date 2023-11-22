class SessionService
  class AuthenticationError < StandardError; end

  MOCKED_LOGINS = [
    { email: 'professor@ic.uff.br', password: 'professor' },
    { email: 'aluno@id.uff.br', password: 'aluno' },
  ]

  def initialize(email, password, auth_type, auth_token)
    @email = email
    @password = password
    @auth_type = auth_type
    @auth_token = auth_token
  end

  def authenticate!
    existing_token = Access.find_by(user_token: @auth_token)
    return existing_token if existing_token&.expires_at&.future?

    response = make_http_request
    raise AuthenticationError, 'Invalid credentials' unless response[:status] == 200

    save_session!(response[:body])
  end

  private

  # TODO Mocked request
  def make_http_request
    account = MOCKED_LOGINS.find { |login| login[:email] == @email }
    if !account.blank? && !account[:email].blank? && @password == account[:password]
      return {
        status: 200,
        body: { 'token' => DateTime.current.to_i.to_s }.to_json
      }
    end

    { status: 403 }
  end

  def save_session!(body)
    parsed_body = JSON.parse(body)

    Access.create!(
      user_email: @email,
      user_token: parsed_body['token'],
      auth_type: @auth_type,
      expires_at: 1.day.from_now
    )
  end
end
