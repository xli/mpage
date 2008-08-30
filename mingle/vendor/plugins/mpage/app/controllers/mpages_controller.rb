class MpagesController < ApplicationController
  
  def index
    @action_view = action_view
    stylesheet_source = Synthesis::AssetPackage.targets_from_sources("stylesheets", ['base']).first
    stylesheet = @action_view.prepend_protocol_with_host_and_port(@action_view.send(:stylesheet_path, stylesheet_source))

    @page = @project.pages.find_by_name(params[:pagename]) || @project.pages.find_by_identifier(params[:pagename])
    #for render charts
    unless @page
      render_json({:stylesheet => stylesheet, :content => "Couldn't find page #{params[:pagename].to_s.bold}"}.to_json, params[:jsonp])
      return
    end
    
    session[:renderable_preview_content] = @page.content
    content = @page.formatted_content_preview(@action_view)
    
    render_json({:stylesheet => stylesheet, :content => content}.to_json, params[:jsonp])
  end

  private

  def action_view
    add_variables_to_assigns
    returning self.class.send(:view_class).new(template_root, @assigns, self) do |view|
      view.instance_eval do
        def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
          options = options.is_a?(String) ? prepend_protocol_with_host_and_port(options) : options.merge(:only_path => false)
          super(name, options, html_options, parameters_for_method_reference)
        end
        
        def url_for(options = {}, *parameters_for_method_reference)
          options = options.is_a?(String) ? prepend_protocol_with_host_and_port(options) : options.merge(:only_path => false)
          super(options, parameters_for_method_reference)
        end
      end
    end
  end
end


