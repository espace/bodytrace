module AuthHelper
  def http_login_for_bodytrace_measurements
    user = 'body_trace'
    pw = 'm345ur3m3n757r4c3b0dy'
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    @env ||= {}
    @env['HTTP_AUTHORIZATION'] = credentials
  end  
end
