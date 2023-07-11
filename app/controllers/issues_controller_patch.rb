module RedmineViewIssueDescription
  module Patches
    module IssuesControllerPatch
      module InstanceMethods
        def show
          super
          if api_request? && (include_changesets_new? || (Redmine::Plugin.installed?('redmine_contacts_helpdesk') && @issue.respond_to?(:helpdesk_ticket) && @issue.helpdesk_ticket))
            Rails.logger.error("Rendering custom API: redmine_view_issue_description => issues/redmine_view_issue_description/show.api")
            respond_to do |format|
              format.api { render 'issues/redmine_view_issue_description/show.api' }
            end
          end
        end

        private
        def include_changesets_new?
          params[:include] == 'changesets_new'
        end
      end
    end
  end
end

IssuesController.prepend(RedmineViewIssueDescription::Patches::IssuesControllerPatch::InstanceMethods)
