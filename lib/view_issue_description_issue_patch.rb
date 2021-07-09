require_dependency 'issue'

module ViewIssueDescriptionIssuePatch
  module InstanceMethods
    def visible?(usr=nil)
      visible = super

      unless (usr || User.current).admin? || self.author == user || user.is_or_belongs_to?(assigned_to) || !visible
        visible = (usr || User.current).allowed_to?(:view_issue_description, self.project)
      end
      visible

    end
  end
end
