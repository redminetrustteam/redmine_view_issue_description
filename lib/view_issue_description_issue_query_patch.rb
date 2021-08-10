require_dependency 'issue_query'

module ViewIssueDescriptionIssueQueryPatch
  module InstanceMethods
    def initialize_available_filters
      super
      add_available_filter("rootissue_id", :type => :tree, :label => :label_rootissue)
    end

    def sql_for_rootissue_id_field(field, operator, value)
      case operator
      when "="
        # accepts a comma separated list of ids
        ids = value.first.to_s.scan(/\d+/).map(&:to_i)
        if ids.present?
          "#{Issue.table_name}.root_id IN (#{ids.join(",")})"
        else
          "1=0"
        end
      when "~"
        issue = Issue.where(:id => value.first.to_i).first
        if issue && (issue_ids = issue.self_and_descendants.pluck(:id)).any?
          "#{Issue.table_name}.id IN (#{issue_ids.join(',')})"
        else
          "1=0"
        end
      when "!*"
        "#{Issue.table_name}.root_id IS NULL"
      when "*"
        "#{Issue.table_name}.root_id IS NOT NULL"
      end
    end

  end
end
