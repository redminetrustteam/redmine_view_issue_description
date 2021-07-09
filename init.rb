require 'redmine'

require_dependency 'view_issue_description_issue_patch'
require_dependency 'view_issue_description_query_patch'
require_dependency 'activities_controller_override'

Rails.configuration.to_prepare do
  unless Issue.included_modules.include?(ViewIssueDescriptionIssuePatch)
    Issue.send(:prepend, ViewIssueDescriptionIssuePatch::InstanceMethods)
  end
  unless Query.included_modules.include?(ViewIssueDescriptionQueryPatch)
    Query.send(:prepend, ViewIssueDescriptionQueryPatch::InstanceMethods)
  end
  unless ActivitiesController.included_modules.include?(ActivitiesControllerOverride)
    ActivitiesController.send(:prepend, ActivitiesControllerOverride::InstanceMethods)
  end
end

Redmine::Plugin.register :redmine_view_issue_description do
  name 'Redmine View Issue Description plugin'
  author 'Jan Catrysse'
  description 'Redmine plugin to add permissions to view issue description and the activity tab'
  version '0.0.1'
  url 'https://github.com/jcatrysse/redmine_hide_issue_description'
  author_url 'https://github.com/jcatrysse'

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
    menu.push :activity, { :controller => 'activities', :action => 'index' }, after: :projects, :if => Proc.new { User.current.admin? || User.current.allowed_to?(:view_activities_global, nil, :global => true) }
  end

  Redmine::MenuManager.map :project_menu do |menu|
    #menu.push :activity, { :controller => 'activities', :action => 'index' }, after: :overview, param: :project_id, :if => Proc.new { User.current.admin? || User.current.allowed_to?(:view_activities, Project.find(params[:project_id])) }
  end

  Redmine::MenuManager.map :project_menu do |menu|
    menu.push :activity, { :controller => 'activities', :action => 'index' }, after: :overview, param: :project_id, :if => Proc.new {  |p| User.current.allowed_to?(:view_activities, p)  }
  end

end