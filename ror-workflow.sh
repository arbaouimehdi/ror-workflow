#!/bin/sh

echo "
#    _____   ____  _____   __          __        _     __ _               
#   |  __ \ / __ \|  __ \  \ \        / /       | |   / _| |              
#   | |__) | |  | | |__) |  \ \  /\  / ___  _ __| | _| |_| | _____      __
#   |  _  /| |  | |  _  /    \ \/  \/ / _ \| '__| |/ |  _| |/ _ \ \ /\ / /
#   | | \ \| |__| | | \ \     \  /\  | (_) | |  |   <| | | | (_) \ V  V / 
#   |_|  \_\\____/|_|  \_\     \/  \/ \___/|_|  |_|\_|_| |_|\___/ \_/\_/  
#                                                                         
#
"

if [ ! -z "$1" ]; then

    # Check if the folder already created
    # If so, remove it
    #sudo rm -r $1

    # Create and Enter to the Folder of the new app
    #mkdir $1
    #cd $1

    # Copy the Gemfile and .gitignore to the application folder
    #cp ../templates/Gemfile ../templates/.gitignore .

    # Install Bundles
    #bundle install

    # Create the New APP
    #rails new . -d mysql --webpack --skip-git --skip-gemfile --skip-test

    # Set the Environment to development
    #bin/rails db:environment:set RAILS_ENV=development

    # Install Rspec
    #rails generate rspec:install

    # Install Cucumber
    rails generate cucumber:install

    # Install Devise, plus generate the Views and the Migration
    rails generate devise:install
    rails generate devise:views
    rails generate devise User

    # Create and Migrate the Database
    bin/rails db:drop db:create db:migrate RAILS_ENV=development
    rails generate controller home index --no-helper --no-assets --no-controller-specs --no-view-specs

    #
    #
    #
    #
    #
    # Devise Config Files
    echo "\n\n1 + Add these two lines to 'config/routes.rb'"
    echo "root to: 'home#index'"
    echo "devise_for :users\n"
    #
    echo "2 + Add this line to 'config/environments/development.rb' "
    echo "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n"
    #
    echo "3 + Optional: Add this line to 'app/controllers/application_controller.rb'"
    echo "before_action :authenticate_user! \n"

    ################### Stop
    read -p "next step? (y/n) " -n 1
    echo "Good Bye"
     
    #
    # If Devise is configured
    if [[ $REPLY =~ ^[Yy]$ ]]; then

      # Rspec Config File
      echo  "'rails_helper.rb' will be modified with the new version"
      cp ../templates/spec/rails_helper.rb spec/

      # Factory Girl
      cp ../templates/spec/factories/users.rb spec/factories/

      # Guard
      bundle exec guard init rspec

      #
      #
      #
      #
      #
      # Webpack Config Files
      echo "4 + Remove this line form 'views/layouts/application.html.erb'"
      echo "<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>\n"

      #
      echo "5 + And replace it with theses two lines on the <head></head> section"
      echo "
      <meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">
      <%= csrf_meta_tags %>
      <%= javascript_pack_tag 'application' %>
      <%= stylesheet_pack_tag 'application' %>"

      # Install Yarn Dependencies
      cp ../templates/package.json .
      sed "1,/my-app/ s/$1/replacement/" package.json
      yarn install

      #
      #
      #
      #
      #
      # Theme Files
      cp ../templates/app/views/layouts/_notices.html.erb app/views/layouts

      #
      #
      #
      #
      # The End
      echo "7 + Run these commands on separate consoles"
      echo "rails server"
      echo "yarn dev_server"
      echo "rails console"

    fi

else
  echo " + You need to set the app name 'example: ./run.sh app_name' \n"

fi


