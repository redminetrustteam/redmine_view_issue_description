require_dependency 'query'
module RedmineViewIssueDescription
  module Patches
    module QueryInclude
      def self.included(base)
        if base.operators_by_filter_type.key?(:date)
          base.operators_by_filter_type[:date].insert(3, "!") unless base.operators_by_filter_type[:date].include?('!')
        end
      end
    end

    module InstanceMethods
      def columns
        cols = super.reject do |col|
          col.name == :description && !User.current.admin? && !User.current.allowed_to?(:view_issue_description, self.project)
        end
      end

      def available_block_columns
        cols = super.reject do |col|
          col.name == :description && !User.current.admin? && !User.current.allowed_to?(:view_issue_description, self.project)
        end
      end

      def has_column?(column)
        column_name = column.is_a?(QueryColumn) ? column.name : column
        if column_name == :description
          return false if !User.current.admin? && !User.current.allowed_to?(:view_issue_description, self.project)
        end
        super(column)
      end
    end
  end
end
