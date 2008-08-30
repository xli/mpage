
module BasicAuthJsonSupport
  def self.included(base)
    base.class_eval do
      alias_method_chain :access_denied, :json
    end
  end
  def access_denied_with_json
    unless performed?
      if params[:format] == 'json' || params[:action] == 'chart'
        headers["WWW-Authenticate"] = %(Basic realm="Welcome Mingle")
        render_json('Incorrect username or password.'.to_json, nil, 401)
      else
        access_denied_without_json
      end
    end
  end
end

LoginSystem.send(:include, BasicAuthJsonSupport)
