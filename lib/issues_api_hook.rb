module IssuesApiHook
  module Hooks
    class MyHook < Redmine::Hook::ViewListener
      def root_api(&block)
        any(:xml, :json, &block)
      end
      if Redmine::Plugin.installed?('redmine_contacts_helpdesk')
        render_on :view_issues_show_api_helpdesk, :partial => 'issues/helpdesk_rest_api_patch'
      end
      render_on :view_issues_show_api_changesets, :partial => 'issues/changesets_rest_api_patch'
    end
  end
end
