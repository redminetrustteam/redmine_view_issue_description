if Rails::VERSION::MAJOR >= 5
  version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}".to_f
  preparation_class = ActiveSupport::Reloader
else
  preparation_class = ActionDispatch::Callbacks
end

require_dependency  'redmine_view_issue_description/patches/issue_patch'
require_dependency  'redmine_view_issue_description/patches/issue_query_patch'
require_dependency  'redmine_view_issue_description/patches/query_include_patch'
require_dependency  'redmine_view_issue_description/patches/issues_controller_patch'

if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
  Rails.autoloaders.main.ignore(File.dirname(__FILE__) + '/lib')
  Rails.autoloaders.main.ignore(File.dirname(__FILE__) + '/lib/redmine_view_issue_description')
  Rails.autoloaders.main.ignore(File.dirname(__FILE__) + '/lib/redmine_view_issue_description/patches')
end

preparation_class.to_prepare do
  unless Issue.included_modules.include?(RedmineViewIssueDescription::Patches::IssuePatch::InstanceMethods)
    Issue.prepend(RedmineViewIssueDescription::Patches::IssuePatch::InstanceMethods)
  end
  unless IssueQuery.included_modules.include?(RedmineViewIssueDescription::Patches::IssueQueryPatch::InstanceMethods)
    IssueQuery.prepend(RedmineViewIssueDescription::Patches::IssueQueryPatch::InstanceMethods)
  end
  unless Query.included_modules.include?(RedmineViewIssueDescription::Patches::InstanceMethods)
    Query.prepend(RedmineViewIssueDescription::Patches::InstanceMethods)
    Query.include(RedmineViewIssueDescription::Patches::QueryInclude)
  end
  unless ActivitiesController.included_modules.include?(ActivitiesControllerOverride::InstanceMethods)
    ActivitiesController.prepend(ActivitiesControllerOverride::InstanceMethods)
  end
  unless IssuesController.included_modules.include?(RedmineViewIssueDescription::Patches::IssuesControllerPatch::InstanceMethods)
    IssuesController.prepend(RedmineViewIssueDescription::Patches::IssuesControllerPatch::InstanceMethods)
  end
end

Redmine::Plugin.register :redmine_view_issue_description do
  name 'Redmine View Issue Description plugin'
  author 'Jan Catrysse'
  description 'Redmine plugin to add permissions to view issue description and the activity tabs'
  version '0.1.0'
  url 'https://github.com/redminetrustteam/redmine_view_issue_description'
  author_url 'https://github.com/redminetrustteam'

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
