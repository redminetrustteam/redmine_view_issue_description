require_dependency 'issue'
module RedmineViewIssueDescription
  module Patches
    module IssuePatch
      module InstanceMethods
        def visible_with_vid?(usr = nil)
          return false unless visible_without_vid?(usr)

          user = usr || User.current

          return true if user.admin?
          #return true if self.author == user
          return true if user.is_or_belongs_to?(assigned_to)

          project_roles = user.roles_for_project(self.project)
          return true if project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) }
          return true if user.allowed_to?(:view_issue_description, self.project) && project_roles.any? { |role| role.permissions_tracker_ids?(:view_issue_description, self.tracker.id) }

          false
        end
      end
    end
  end
end

Issue.include(RedmineViewIssueDescription::Patches::IssuePatch::InstanceMethods)
Issue.class_eval do
  alias_method :visible_without_vid?, :visible?
  alias_method :visible?, :visible_with_vid?
end
