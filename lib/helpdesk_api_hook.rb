module HelpdeskApiHook
  module Hooks
    class MyHook < Redmine::Hook::ViewListener
      def root_api(&block)
        any(:xml, :json, &block)
      end

      render_on :view_issues_show_api, :partial => 'issues/helpdesk_rest_api_patch'
    end
  end
end
