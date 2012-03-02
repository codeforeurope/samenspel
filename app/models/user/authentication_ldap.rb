class User
  
  def self.authenticate_with_ldap(login, password)
    logger.info "LDAP login with '#{login}'"

    conf = Teambox.config.ldap_auth_settings
    conf.identifier_key ||= 'uid'
    conf.first_name_key ||= 'givenName'
    conf.last_name_key ||= 'sn'
    conf.email_key ||= 'mail'

    # First query ldap to get the user's full DN
    conn = Net::LDAP.new
    conn.host = conf.host
    conn.port = conf.port
    
    if (conf.bind_dn && conf.bind_password)
      conn.auth conf.bind_dn, conf.bind_password
    end

    filter = Net::LDAP::Filter.eq(conf.identifier_key, login)
    attributes = [:dn, conf.first_name_key, conf.last_name_key, conf.email_key]
    
    logger.debug "Searching #{conf.identifier_key}=#{login},#{conf.base_dn} on #{conf.host}:#{conf.port}"
    result = conn.search(:base => conf.base_dn, :filter => filter, :attributes => attributes)
    
    if (!result || result.empty?)
      logger.debug conn.get_operation_result
      return nil
    else
      dn = result.first.dn
      logger.debug "Found '#{dn}'"
      first_name = result.first[ conf.first_name_key ][0].to_str
      last_name = result.first[ conf.last_name_key ][0].to_str
      email = result.first[ conf.email_key ][0].to_str
      return nil if !dn
    end

    logger.debug "Trying to bind with user\'s password"
    conn.auth dn, password
    conn.bind ? User.create_or_find_by_login(login, first_name, last_name, email) : nil
  end

  def self.create_or_find_by_login(login, first_name, last_name, email)
    user = find_by_login(login)
    
    if !user
      logger.info "Creating new user account for '#{login}' with LDAP authentication"
      user = User.create({
        :email => email,
        :login => login,
        :first_name => first_name,
        :last_name => last_name,
        :uses_ldap_authentication => true
      })
      user.activate!
      user.expire_login_code!
    end

    return user
  end
end