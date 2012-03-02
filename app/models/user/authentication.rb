class User
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  attr_accessor :current_token
  
  def self.authenticate(login, password)
    unless login.blank? or password.blank?
      u = find_by_username_or_email(login)
      if Teambox.config.allow_ldap_auth && (!u || u.uses_ldap_authentication)
        authenticate_with_ldap(login, password)
      else
        u.authenticated?(password) ? u : nil
      end
    end
  end

end