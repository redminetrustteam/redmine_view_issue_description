require_dependency 'issue_query'
module RedmineViewIssueDescription
  module Patches
    module IssueQueryPatch
      module InstanceMethods
        def initialize_available_filters
          super
          add_available_filter("rootissue_id", :type => :tree, :label => :label_rootissue)
        end

        def sql_for_rootissue_id_field(field, operator, value)
          case operator
          when "="
            # accepts a comma separated list of ids
            ids = value.first.to_s.scan(/\d+/)
            condition = ids.empty? ? "1=0" : "#{Issue.table_name}.root_id IN (#{ids.join(",")})"
          when "~"
            # accepts a comma separated list of ids
            ids = value.first.to_s.scan(/\d+/)
            condition = ids.empty? ? "1=0" : "#{Issue.table_name}.root_id IN (#{ids.join(",")})"
          when "!*"
            "#{Issue.table_name}.root_id IS NULL"
          when "*"
            "#{Issue.table_name}.root_id IS NOT NULL"
          else
            # type code here
          end
        end
      end
    end
  end
end

IssueQuery.prepend(RedmineViewIssueDescription::Patches::IssueQueryPatch::InstanceMethods)
