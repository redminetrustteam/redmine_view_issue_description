module ActivitiesControllerOverride
  module InstanceMethods
    def index
      unless User.current.admin?
        if User.current.allowed_to?(:view_activities, @project)
          authorize_activities(false)
        else
          authorize_activities_global
        end
      end
      super
    end

    private

    def authorize_activities(global)
      if User.current.allowed_to?(:view_activities, @project)
        authorize :custom_activities, :index, global
      else
        authorize_activities_global(global)
      end
    end

    def authorize_activities_global(global = true)
      if User.current.allowed_to?(:view_activities_global, nil, global: true) && @project.nil?
        authorize :custom_activities_global, :index, global
      else
        authorize :custom_activities, :index, global
      end
    end
  end
end