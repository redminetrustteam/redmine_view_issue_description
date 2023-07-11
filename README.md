# Redmine plugin: View Issue Description

This plugin adds the possibility to limit the **visibility** of **issue descriptions**, based on _role permissions_ and _selected trackers_.
The main goal is to limit the visibility for external users (e.g., customers), without hiding an essential issue overview and issue related information.

Long story short, without the new `view_issue_description` permission, a user cannot enter an issue or view its description.
An exception is made for own issues (author or assigned user).

Some extra features have been added, to improve the general usability.

## Features
1. Project module `issue_tracking` has an extended permission: `view_issue_description`
1. Project module `project` has extended permission:
    * `view_activities`
    * `view_activities_global`
1. Filters `start_date` and `end_date` have been extended with a `not equal to` operator.
1. Filter `root_issue_id` has been added.
1. API calls on `issues` have been extended with:
    * `repository` information if set `include=changesets_new`
    * `helpdesk_ticket` information if the `RedmineUP` helpdesk plugin is installed.
    * Set `include=journal_messages,journals` for helpdesk journals.

## Installation

1. Move the files into `$REDMINE/plugins/redmine_view_issue_description`
2. Restart REDMINE.

## Usage

1. Set the permission of `view_issue_description`, `view_activities`, `view_activities_global`
2. API: https://site.url/issues/<issue_id_here>.json
3. API: https://site.url/issues/<issue_id_here>.json?include=journal_messages,journals
4. API: https://site.url/issues/<issue_id_here>.json?include=changesets_new

## Compatibility

1. Tested on Redmine 4.1.2
1. Tested on Redmine 5.0.5
