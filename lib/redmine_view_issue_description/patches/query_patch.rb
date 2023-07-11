require_dependency 'query'
module RedmineViewIssueDescription
  module Patches
    module QueryPatch
      module InstanceMethods
        def columns
          project_roles = User.current.roles_for_project(self.project)
          super.reject { |col| col.name == :description && !User.current.admin? && !project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) } }
        end

        def available_block_columns
          project_roles = User.current.roles_for_project(self.project)
          super.reject { |col| col.name == :description && !User.current.admin? && !project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) } }
        end

        def has_column?(column)
          project_roles = User.current.roles_for_project(self.project)
          column_name = column.is_a?(QueryColumn) ? column.name : column
          if column_name == :description
            return false if !User.current.admin? && !project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) }
          end
          super(column)
        end
      end
    end
  end
end

Query.prepend(RedmineViewIssueDescription::Patches::QueryPatch::InstanceMethods)
