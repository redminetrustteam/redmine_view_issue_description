require_dependency 'query'
module RedmineViewIssueDescription
  module Patches
    module QueryPatch
      module InstanceMethods
        def columns_with_ifv
          project_roles = User.current.roles_for_project(self.project)
          columns_without_ifv.reject { |col| col.name == :description && !User.current.admin? && !project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) } }
        end

        def available_block_columns_with_ifv
          project_roles = User.current.roles_for_project(self.project)
          available_block_columns_without_ifv.reject { |col| col.name == :description && !User.current.admin? && !project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) } }
        end

        def has_column_with_ifv?(column)
          project_roles = User.current.roles_for_project(self.project)
          column_name = column.is_a?(QueryColumn) ? column.name : column
          if column_name == :description
            return false if !User.current.admin? && !project_roles.any? { |role| role.permissions_all_trackers?(:view_issue_description) }
          end
          has_column_without_ifv?(column)
        end
      end
    end
  end
end

Query.include(RedmineViewIssueDescription::Patches::QueryPatch::InstanceMethods)
Query.class_eval do
  alias_method :columns_without_ifv, :columns
  alias_method :columns, :columns_with_ifv
  alias_method :available_block_columns_without_ifv, :available_block_columns
  alias_method :available_block_columns, :available_block_columns_with_ifv
  alias_method :has_column_without_ifv?, :has_column?
  alias_method :has_column?, :has_column_with_ifv?
end
