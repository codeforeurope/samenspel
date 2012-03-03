class User

  def self.authenticate_with_ldap(login, password)
    logger.info "LDAP login with '#{login}'"

    # First query ldap to get the user's info
    ldap_user = User.find_in_ldap(login)
    return nil if !ldap_user

    # Then try to bind with user's password
    logger.debug "Trying to bind with user\'s password"
    conn = User.create_ldap_connection
    conn.auth ldap_user[:dn], password
    
    if conn.bind
      logger.info "LDAP authentication successful"
      return find_by_login(login) || User.create_from_ldap(ldap_user)
    else
      return nil
    end
  end
  
  # Search LDAP for given login and if finds create account (for invitations)
  def self.find_in_ldap_and_create(login)
    ldap_user = User.find_in_ldap(login)
    ldap_user ? User.create_from_ldap(ldap_user) : nil
  end

  def self.find_in_ldap(login)
    conf = Teambox.config.ldap_auth_settings

    conn = User.create_ldap_connection
    filter = Net::LDAP::Filter.eq(conf.identifier_key, login)
    attributes = [:dn, conf.first_name_key, conf.last_name_key, conf.email_key]
    
    logger.debug "Searching #{conf.identifier_key}=#{login},#{conf.base_dn} on #{conf.host}:#{conf.port}"
    result = conn.search(:base => conf.base_dn, :filter => filter, :attributes => attributes)
    
    if !result || result.empty?
      logger.debug conn.get_operation_result
      return nil
    end

    dn = result.first.dn
    first_name = result.first[ conf.first_name_key ][0]
    last_name = result.first[ conf.last_name_key ][0]
    email = result.first[ conf.email_key ][0]
    
    logger.debug "Found #{dn}: #{first_name}, #{last_name}, #{email}"
    if !dn || !first_name || !last_name || !email
      logger.info "One of the required attributes in LDAP entry is null"
      return nil
    end
    
    # Net::LDAP doesn't return string object; to_str is really necessary (tested)
    return {
      :dn => dn,
      :login => login,
      :first_name => first_name.to_str,
      :last_name => last_name.to_str,
      :email => email.to_str
    }
  end


  private
  
    def self.create_ldap_connection
      conf = Teambox.config.ldap_auth_settings
      
      conn = Net::LDAP.new
      conn.host = conf.host
      conn.port = conf.port

      if conf.bind_dn && conf.bind_password
        conn.auth conf.bind_dn, conf.bind_password
      end
      return conn
    end
    
    # Create account for user from LDAP
    def self.create_from_ldap(ldap_user)
      logger.info "Creating new user account for '#{ldap_user[:login]}' with LDAP authentication"

      user = User.create({
        :email => ldap_user[:email],
        :login => ldap_user[:login],
        :first_name => ldap_user[:first_name],
        :last_name => ldap_user[:last_name],
        :uses_ldap_authentication => true
      })
      user.activate!
      user.expire_login_code!

      return user
    end
    
end