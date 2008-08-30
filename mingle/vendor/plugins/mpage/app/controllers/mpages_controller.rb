class MpagesController < ApplicationController
  
  def index
    @action_view = action_view
    stylesheet_source = Synthesis::AssetPackage.targets_from_sources("stylesheets", ['base']).first
    stylesheet = @action_view.prepend_protocol_with_host_and_port(@action_view.send(:stylesheet_path, stylesheet_source))

    @page = @project.pages.find_by_name(params[:pagename]) || @project.pages.find_by_identifier(params[:pagename])

    unless @page
      render_json({:stylesheet => stylesheet, :content => "Couldn't find page #{params[:pagename].to_s.bold}"}.to_json, params[:jsonp])
      return
    end
    
    content = @page.formatted_content(@action_view)
    
    render_json({:stylesheet => stylesheet, :content => content}.to_json, params[:jsonp])
  end

  private
  
  def action_view
    add_variables_to_assigns
    returning self.class.send(:view_class).new(template_root, @assigns, self) do |view|
      view.instance_eval do
        def url_for(options = {}, *parameters_for_method_reference)
          url_with_basic_auth(super(options, *parameters_for_method_reference))
        end
        
        def prepend_protocol_with_host_and_port(url)
          url_with_basic_auth(url)
        end
        
        def url_with_basic_auth(url)
          controller.send(:basic_authorization_header) =~ /Basic (.*)/
          login, password = $1.to_s.unpack("m*")[0].split(":", 2)
          "#{controller.request.protocol}#{CGI.escape(login)}:#{CGI.escape(password)}@#{controller.request.host_with_port}#{url}"
        end
      end
    end
  end
end


