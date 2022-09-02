# Tutorial notes

https://www.redmine.org/projects/redmine/wiki/Plugin_Tutorial

### Using git@github.com:sameersbn/docker-redmine.git 4.2-stable to test
```diff
diff --git a/assets/runtime/config/redmine/database.yml b/assets/runtime/config/redmine/database.yml
index 394edfb49c10..dd07ff0fb20d 100644
--- a/assets/runtime/config/redmine/database.yml
+++ b/assets/runtime/config/redmine/database.yml
@@ -9,3 +9,15 @@ production:
   password: '{{DB_PASS}}'
   pool: {{DB_POOL}}
   {{DB_SSL_MODE}}
+
+test:
+  adapter: {{DB_ADAPTER}}
+  encoding: {{DB_ENCODING}}
+  reconnect: false
+  database: {{DB_NAME}}
+  host: {{DB_HOST}}
+  port: {{DB_PORT}}
+  username: {{DB_USER}}
+  password: '{{DB_PASS}}'
+  pool: {{DB_POOL}}
+  {{DB_SSL_MODE}}
diff --git a/docker-compose.yml b/docker-compose.yml
index a4af85a67b50..09d3ff7a3c65 100644
--- a/docker-compose.yml
+++ b/docker-compose.yml
@@ -23,8 +23,9 @@ services:
     - DB_PORT=5432
     - DB_USER=redmine
     - DB_PASS=password
-    - DB_NAME=redmine_production
+    - DB_NAME=redmine_test
     - DB_SSL_MODE=prefer
+    - RAILS_ENV=test
 
     - REDMINE_PORT=10083
     - REDMINE_HTTPS=false
```

Launch redmine and get shell
```
docker-compose up -d
docker-compose exec redmine bash
```

Tutorial
```
bundle exec rails generate redmine_plugin private_email

bundle exec rails generate redmine_plugin_model private_email poll question:string yes:integer no:integer

RAILS_ENV=test bundle exec rake redmine:plugins:migrate

RAILS_ENV=test bundle exec rails console << EOF
Poll.create(question: "Can you see this poll")
Poll.create(question: "And can you see this other poll")
exit
EOF

cat << EOF > plugins/private_email/app/models/poll.rb
class Poll < ActiveRecord::Base
  def vote(answer)
    increment(answer == 'yes' ? :yes : :no)
  end
end
EOF

bundle exec rails generate redmine_plugin_controller private_email polls index vote

cat << EOF > plugins/private_email/app/controllers/polls_controller.rb
class PollsController < ApplicationController
  def index
    @polls = Poll.all
  end

  def vote
    poll = Poll.find(params[:id])
    poll.vote(params[:answer])
    if poll.save
      flash[:notice] = 'Vote saved.'
    end
    redirect_to polls_path(project_id: params[:project_id])
  end
end
EOF

cat << EOF > plugins/private_email/app/views/polls/index.html.erb
<h2>Polls</h2>

<% @polls.each do |poll| %>
  <p>
    <%= poll.question %>?
    <%= link_to 'Yes', { action: 'vote', id: poll[:id], answer: 'yes', project_id: @project }, method: :post %> <%= poll.yes %> /
    <%= link_to 'No', { action: 'vote', id: poll[:id], answer: 'no', project_id: @project }, method: :post %> <%= poll.no %>
  </p>
<% end %>
EOF

cat << EOF >> plugins/private_email/config/routes.rb
get 'polls', to: 'polls#index'
post 'post/:id/vote', to: 'polls#vote'
EOF


cat << EOF > plugins/private_email/test/functional/polls_controller_test.rb
require File.expand_path('../../test_helper', __FILE__)
class PollsControllerTest < ActionController::TestCase
  fixtures :projects

  def test_index
	@request.session[:user_id] = 2
    get :index, params: { project_id: 1 }

    assert_response :success
  end
end
EOF
```

Run tests
```
bundle config set --local without ""
bundle install
#RAILS_ENV=test bundle exec rake db:drop db:create db:migrate redmine:plugins:migrate
RAILS_ENV=test bundle exec rake test TEST=plugins/private_email/test/functional/polls_controller_test.rb
RAILS_ENV=test bundle exec rake test TEST=plugins/private_email/test/unit/poll_test.rb 

# Running redmine mailer tests
RAILS_ENV=test bundle exec rake test TEST=test/unit/mailer_test.rb
```