module ActivitiesControllerOverride
  module InstanceMethods
    def index
      unless User.current.admin?
        if User.current.allowed_to?(:view_activities, @project)
          authorize :custom_activities, :index, false
        else
          if User.current.allowed_to?(:view_activities_global, nil, :global => true) && @project == nil
            authorize :custom_activities_global, :index, true
          else
            authorize :custom_activities, :index, false
          end
        end
      end
      super
    end
  end
end
