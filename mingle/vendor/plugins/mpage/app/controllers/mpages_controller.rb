class MpagesController < ApplicationController
  unloadable #fix reloading controller can't reload ApplicationController problem

  skip_before_filter :authenticated?, :require_project_membership_or_admin, :only => ['show', 'chart']
  verify :method => :post, :only => [ :create ], :redirect_to => { :action => :index }

  def index
    @page_names = @project.pages.collect(&:name)
  end

  def create
    @mpage_url = mpage_url(:page_name => "m#{@project.encrypt(params[:page_name])}")
  end

  def show
    @page_name = @project.decrypt(params[:page_name][1..-1])
    @page = @project.pages.find_by_name(@page_name) || @project.pages.find_by_identifier(@page_name)
  rescue
    render(:json => {:content => "Couldn't find page #{@page_name.to_s.bold}"}.to_json, :callback => Mpage::JS_CALLBACK)
  end

  def chart
    page_name = @project.decrypt(params[:pagename])
    @page = @project.pages.find_by_identifier(page_name)
    if @page
      content = @page.content
      chart = Chart.extract(content, params[:type], params[:position].to_i, :host_project => @project, :content_provider => @page)
      send_data(chart.generate, :type => "image/png",:disposition => "inline")
    else
      render :text => 'Dont, please'
    end
  end
end
