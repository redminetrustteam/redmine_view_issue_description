require_dependency 'issue'

module HideIssueDescriptionIssuePatch
  module InstanceMethods
    def visible?(usr=nil)

      return false unless super(usr)
      return true if (usr || User.current).admin?
      return false if (usr || User.current).allowed_to?(:hide_view_issue_description, self.project)

      return true
    end
  end
end
