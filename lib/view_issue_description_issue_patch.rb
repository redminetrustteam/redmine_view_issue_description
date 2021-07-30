require_dependency 'issue'

module ViewIssueDescriptionIssuePatch
  module InstanceMethods
    def visible?(usr=nil)
      visible = super

      unless (usr || User.current).admin? || self.author == (usr || User.current) || (usr || User.current).is_or_belongs_to?(assigned_to) || !visible
        visible = (usr || User.current).allowed_to?(:view_issue_description, self.project, global: true)
        unless visible
          tracker_permission_flag = "view_issue_description_#{self.tracker.name.downcase.gsub(/[^a-z0-9]+/, '_')}".to_sym
          visible = (usr || User.current).allowed_to?(tracker_permission_flag, self.project, global: true)
        end
      end
      visible

    end
  end
end
