#require 'redmine'

require_dependency 'view_issue_description_issue_patch'
require_dependency 'view_issue_description_query_patch'
require_dependency 'view_issue_description_issue_query_patch'
require_dependency 'activities_controller_override'
require_dependency 'tracker_helper'
require_dependency 'issues_api_hook'

Rails.configuration.to_prepare do
  unless Issue.included_modules.include?(ViewIssueDescriptionIssuePatch)
    Issue.send(:prepend, ViewIssueDescriptionIssuePatch::InstanceMethods)
  end
  unless IssueQuery.included_modules.include?(ViewIssueDescriptionIssueQueryPatch)
    IssueQuery.send(:prepend, ViewIssueDescriptionIssueQueryPatch::InstanceMethods)
  end
  unless Query.included_modules.include?(ViewIssueDescriptionQueryPatch)
    Query.send(:prepend, ViewIssueDescriptionQueryPatch::InstanceMethods)
    Query.send(:include, ViewIssueDescriptionQueryPatch::QueryInclude)
  end
  unless ActivitiesController.included_modules.include?(ActivitiesControllerOverride)
    ActivitiesController.send(:prepend, ActivitiesControllerOverride::InstanceMethods)
  end
end

Redmine::Plugin.register :redmine_view_issue_description do
  name 'Redmine View Issue Description plugin'
  author 'Jan Catrysse'
  description 'Redmine plugin to add permissions to view issue description and the activity tab'
  version '0.0.3'
  url 'https://github.com/redminetrustteam/redmine_view_issue_description'
  author_url 'https://github.com/redminetrustteam'

  project_module :issue_description do
    Tracker.all.each do |t|
      RedmineTrackControl::TrackerHelper.add_tracker_permission(t,"view_issue_description")
    end
  end

  project_module :issue_tracking do
    permission :view_issue_description, {:custom_issue_description => [:index]}
  end

  permission :view_activities_global, {:custom_activities_global => [:index]}
  permission :view_activities, {:custom_activities => [:index]}

  Redmine::MenuManager.map :application_menu do |menu|
    menu.delete :activity
  end

  Redmine::MenuManager.map :project_menu do |menu|
    menu.delete :activity
  end

  Redmine::MenuManager.map :application_menu do |menu|
    menu.push :activity, { :controller => 'activities', :action => 'index', :id => nil }, after: :projects, :if => Proc.new { User.current.admin? || User.current.allowed_to?(:view_activities_global, nil, :global => true) }
  end

  Redmine::MenuManager.map :project_menu do |menu|
    menu.push :activity, { :controller => 'activities', :action => 'index' }, after: :overview, :if => Proc.new {  |p| User.current.allowed_to?(:view_activities, p)  }
  end

end