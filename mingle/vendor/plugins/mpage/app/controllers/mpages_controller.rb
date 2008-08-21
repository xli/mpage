class MpagesController < ApplicationController
  
  def index
    @page = @project.pages.find_by_name(params[:pagename])
    session[:renderable_preview_content] = @page.content
    
    content = @page.formatted_content_preview(action_view)
    
    respond_to do |format|
      format.json do
        headers["Content-Type"] = "application/javascript"
        render :text => "#{params[:jsonp]}(#{content.inspect})"
      end
    end
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


