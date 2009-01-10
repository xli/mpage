with_options :controller => "mpages" do |mpages|
  mpages.mpage 'projects/:project_id/mapges/:page_name', :page_name => /(m.+)/, :action => 'show'
end
