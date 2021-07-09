module ViewIssueDescriptionQueryPatch
  module InstanceMethods
    def columns
      cols = []
      super.each do |col|
        if (col.name != :description) ||
            (User.current.admin?) ||
            ! User.current.allowed_to?(:view_issue_description, self.project) ||
            ! User.current.allowed_to?(:view_issue_description, nil, :global => true)
          cols << col
        end
      end
      cols
    end

    def available_block_columns
      cols = []
      super.each do |col|
        if (col.name != :description) ||
            (User.current.admin?) ||
            (! User.current.allowed_to?(:view_issue_description, self.project))
          cols << col
        end
      end
      cols
    end

    def has_column?(column)
      column_name = column.is_a?(QueryColumn) ? column.name : column
      if (column_name == :description) &&
          (! User.current.admin?) &&
          (User.current.allowed_to?(:view_issue_description, self.project))
        return false
      end
      super(column)
    end
  end
end
