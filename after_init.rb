#Redmine::MenuManager.map :project_menu do |menu|
#  menu.push :activity, { :controller => 'activities', :action => 'index' }, after: :overview, param: :project_id, :if => Proc.new {  |p| User.current.allowed_to?(:view_activities, p)  }
#end