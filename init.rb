Redmine::Plugin.register :redmine_view_issue_description do
  name 'Redmine View Issue Description plugin'
  author 'Jan Catrysse'
  description 'Redmine plugin to add permissions to view issue description and the activity tabs'
  version '0.1.0'
  url 'https://github.com/redminetrustteam/redmine_view_issue_description'
  author_url 'https://github.com/redminetrustteam'

  project_module :issue_tracking do
    permission :view_issue_description, {}
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

if Rails::VERSION::MAJOR >= 5
  version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}".to_f
  PLUGIN_MIGRATION_CLASS = ActiveRecord::Migration[version]
  preparation_class = ActiveSupport::Reloader
else
  PLUGIN_MIGRATION_CLASS = ActiveRecord::Migration
  preparation_class = ActionDispatch::Callbacks
end

preparation_class.to_prepare do
  require_dependency  'redmine_view_issue_description/patches/issue_patch'
  require_dependency  'redmine_view_issue_description/patches/issue_query_patch'
  require_dependency  'redmine_view_issue_description/patches/query_patch'
  require_dependency  'redmine_view_issue_description/patches/query_include'
end
