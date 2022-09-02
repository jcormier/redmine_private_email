Redmine plugin to remove potentially sensitive info from email notifications

Plugin overrides the mailer templates used to send emails to users.  Templates have mostly just had any descriptions, private notes, and attachments removed from them so only the title of the issue, note, document, wiki, forum is sent.

Tested on redmine 4.2.3

# To install
* Clone git to plugins directory
```
git clone https://github.com/jcormier/redmine_private_email.git
```
* Restart redmine

# To update to future version of redmine:
* cd to redmine app/views/mailer
* Copy files to plugin directory app/views/mailer (renaming them to .orig)
```
for f in *; do cp -v $f plugins/redmine_private_email/app/views/mailer/"$f.orig"; done
```
* Use git status to determine if any files have changed and updated the non .orig files appropriately


# Rendered after issue edit
Log of what templates get parsed when doing an issue update
```ruby
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc] Performing ActionMailer::DeliveryJob (Job ID: d671c291-7cd1-41d7-80b6-e280fa4e2fcc) from Async(mailers) with arguments: "Mailer", "issue_edit",          "deliver_now", #<GlobalID:0x000055ff17a6ce78 @uri=#<URI::GID gid://redmine-app/User/2>>, #<GlobalID:                0x000055ff17a5b560 @uri=#<URI::GID gid://redmine-app/Journal/11>>
  Current user: admin (id=1)
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f] Performing ActionMailer::DeliveryJob (Job ID: 9696aea7-01bc-4520-92de-ceefa83cf96f) from Async(mailers) with arguments: "Mailer", "issue_edit",          "deliver_now", #<GlobalID:0x000055ff179dc968 @uri=#<URI::GID gid://redmine-app/User/1>>, #<GlobalID:                0x000055ff179d7a80 @uri=#<URI::GID gid://redmine-app/Journal/11>>
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc]   Rendering mailer/issue_edit.text.  erb within layouts/mailer
  Rendering issues/show.html.erb within layouts/base
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f]   Rendering mailer/issue_edit.text.  erb within layouts/mailer
  Rendered issues/_action_menu.html.erb (1.9ms)
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f]   Rendered plugins/private_email/app/views/mailer/_issue.text.erb (12.9ms)
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f]   Rendered mailer/issue_edit.text.   erb within layouts/mailer (14.6ms)
  Rendered attachments/_links.html.erb (5.9ms)
  Rendered issue_relations/_form.html.erb (0.6ms)
  Rendered issues/_relations.html.erb (0.9ms)
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc]   Rendered plugins/private_email/app/views/mailer/_issue.text.erb (19.5ms)
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc]   Rendered mailer/issue_edit.text.   erb within layouts/mailer (21.2ms)
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f]   Rendering mailer/issue_edit.html.  erb within layouts/mailer
  Rendered issues/tabs/_history.html.erb (2.8ms)
  Rendered common/_tabs.html.erb (3.2ms)
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc]   Rendering mailer/issue_edit.html.  erb within layouts/mailer
  Rendered issues/_action_menu.html.erb (1.3ms)
  Rendered issues/_trackers_description.html.erb (0.3ms)
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f]   Rendered plugins/private_email/app/views/mailer/_issue.html.erb (9.9ms)
[ActiveJob] [ActionMailer::DeliveryJob] [9696aea7-01bc-4520-92de-ceefa83cf96f]   Rendered mailer/issue_edit.html.   erb within layouts/mailer (11.9ms)
  Rendered issues/_form_custom_fields.html.erb (1.3ms)
  Rendered issues/_attributes.html.erb (7.3ms)
  Rendered issues/_form.html.erb (12.6ms)
  Rendered attachments/_form.html.erb (0.8ms)
  Rendered issues/_edit.html.erb (18.5ms)
  Rendered issues/_action_menu_edit.html.erb (19.9ms)
  Rendered issues/_sidebar.html.erb (1.0ms)
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc]   Rendered plugins/private_email/app/views/mailer/_issue.html.erb (3.3ms)
[ActiveJob] [ActionMailer::DeliveryJob] [d671c291-7cd1-41d7-80b6-e280fa4e2fcc]   Rendered mailer/issue_edit.html.   erb within layouts/mailer (23.0ms)
  Rendered watchers/_watchers.html.erb (2.0ms)
  Rendered issues/show.html.erb within layouts/base (47.0ms)
Completed 200 OK in 80ms (Views: 50.1ms | ActiveRecord: 17.4ms)
```