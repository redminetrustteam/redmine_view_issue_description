# CHANGELOG
### 0.1.2
* Correction for more consistent access based on user permissions.
* Removed filter on `root_issue`, has been moved to the `redmine_parent_child_filters` plugin
* Resolved potential issue: `SystemStackError (stack level too deep)`  
  Converted methods to use `alias_method`
* Update `locales`
