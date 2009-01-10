module Mpage
  JS_CALLBACK = 'mpageCallback'

  module URLReplace
    def self.extended(base)
      base.instance_eval do
        alias :url_for_without_mpage_delegation :url_for
        alias :url_for :url_for_with_mpage_delegation
      end
    end

    def url_for_with_mpage_delegation(options={}, *params)
      if options[:action].to_s == 'chart'
        options[:controller] = 'mpages'
        options[:pagename] = @project.encrypt(options[:pagename])
      end
      prepend_protocol_with_host_and_port(url_for_without_mpage_delegation(options, *params))
    rescue
      puts $!.message
      puts $!.backtrace.join("\n")
    end
  end
end