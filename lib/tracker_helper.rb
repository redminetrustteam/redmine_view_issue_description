# Helper module
module TrackerHelper
  def self.add_tracker_permission(tracker, permtype)
    Redmine::AccessControl.map {|map| map.project_module(:issue_description) {|map2|map2.permission(permission(tracker,permtype), {:issues => :index}, {})}}
  end

  def self.permission(tracker, permtype='create')
    #(permtype + "_tracker#{tracker.id}").to_sym
    (permtype + "_#{tracker.name.downcase.gsub(/[^a-z0-9]+/,'_')}").to_sym
  end
end