module ViewIssueDescriptionQueryPatch
  module InstanceMethods
    def columns
      cols = []
      super.each do |col|
        if col.name != :description ||
          User.current.admin? ||
          User.current.allowed_to?(:view_issue_description, self.project) ||
          (self.project == nil && User.current.allowed_to?(:view_issue_description, User.current.projects.to_a))
          cols << col
        end
      end
      cols
    end

    def available_block_columns
      cols = []
      super.each do |col|
        if col.name != :description ||
          User.current.admin? ||
          User.current.allowed_to?(:view_issue_description, self.project) ||
          (self.project == nil && User.current.allowed_to?(:view_issue_description, User.current.projects.to_a))
          cols << col
        end
      end
      cols
    end

    def has_column?(column)
      column_name = column.is_a?(QueryColumn) ? column.name : column
      if column_name == :description &&
        ! User.current.admin? &&
        ! User.current.allowed_to?(:view_issue_description, self.project)
        return false
      end
      super(column)
    end
  end
end
