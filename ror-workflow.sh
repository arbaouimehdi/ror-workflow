#!/bin/sh

echo "
$(tput setaf 2)#    _____   ____  _____   __          __        _     __ _
$(tput setaf 2)#   |  __ \ / __ \|  __ \  \ \        / /       | |   / _| |
$(tput setaf 2)#   | |__) | |  | | |__) |  \ \  /\  / ___  _ __| | _| |_| | _____      __
$(tput setaf 2)#   |  _  /| |  | |  _  /    \ \/  \/ / _ \| '__| |/ |  _| |/ _ \ \ /\ / /
$(tput setaf 2)#   | | \ \| |__| | | \ \     \  /\  | (_) | |  |   <| | | | (_) \ V  V /
$(tput setaf 2)#   |_|  \_\\____/|_|  \_\     \/  \/ \___/|_|  |_|\_|_| |_|\___/ \_/\_/
"

# Colors
RED='\033[0;31m'
GREEN=''

#==================================
#
#        If App Name is Defined
#
#==================================#
if [ ! -z "$1" ]; then

    # Check if the folder already created
    # If so, remove it
    rm -r $1

    # Create and Enter to the Folder of the new app
    mkdir $1
    cd $1

    # Copy the Gemfile and .gitignore to the application folder
    cp ../templates/Gemfile ../templates/.gitignore .

    # Install Bundles
    bundle install

    # Create the New APP
    rails new . -d mysql --webpack --skip-git --skip-gemfile --skip-test

    # Set the Environment to development
    bin/rails db:environment:set RAILS_ENV=development

    # Install Rspec
    rails generate rspec:install

    # Install Cucumber
    rails generate cucumber:install

    # Install Devise, plus generate the Views and the Migration
    rails generate devise:install
    rails generate devise:views
    rails generate devise User


    # Create and Migrate the Database
    bin/rails db:drop db:create db:migrate RAILS_ENV=development
    rails generate controller home index --no-helper --no-assets --no-controller-specs --no-view-specs

    # Add Devise and Home routes
    cp ../templates/config/routes.rb config/

    # Rspec Config File
    echo  "'rails_helper.rb' will be modified with the new version"
    cp ../templates/spec/rails_helper.rb spec/

    # Factory Girl
    cp ../templates/spec/factories/users.rb spec/factories/

    # Guard
    bundle exec guard init rspec

    # Install Yarn Dependencies
    cp ../templates/package.json .
    sed "1,/my-app/ s/$1/replacement/" package.json
    yarn install

    # Remove Unused JS Files and Copy The New Ones
    rm -r app/assets/javascripts app/assets/config
    cp -R ../templates/app/javascript/packs app/javascript/

    # Copy Webpack Config
    cp -R ../templates/config/webpack config/

    # Remove Unused CSS Files and Add The New Ones
    rm app/assets/stylesheets/application.css
    cp -R ../templates/app/assets/stylesheets app/assets/

    # Copy View Files
    cp ../templates/app/views/layouts/* app/views/layouts/

    # Change the Application Title
    sed "1,/myApp/ s/$1/replacement/" app/views/layouts/application.html.erb

    #
    #
    #
    #
    #
    #
    # Messages
    echo "1 + Add this line to 'config/environments/development.rb' "
    tput setaf 3; echo "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n"

    echo "2 + Optional: Add this line to 'app/controllers/application_controller.rb'"
    tput setaf 3; echo "before_action :authenticate_user! \n"

    #
    #
    #
    #
    #
    #
    #
    # Commands to Run
    tput setaf 2; echo "Successful Installation ✌ \n\n"
    echo "7 + Run these commands on separate consoles"
    tput setaf 3; echo "+ rails server"
    tput setaf 3; echo "+ yarn dev_server"
    tput setaf 3; echo "+ rails console"


#==================================
#
#     If App Name isn't Defined
#
#==================================#
else
    tput setaf 7; echo "Notice:"
    tput setaf 1; echo " + You need to set the app name example: $(tput setaf 7)'./ror-workflow.sh app_name' \n"

fi


