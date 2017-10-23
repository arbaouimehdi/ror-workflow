#!/bin/sh

echo "
$(tput setaf 2)#    _____   ____  _____   __          __        _     __ _
$(tput setaf 2)#   |  __ \ / __ \|  __ \  \ \        / /       | |   / _| |
$(tput setaf 2)#   | |__) | |  | | |__) |  \ \  /\  / ___  _ __| | _| |_| | _____      __
$(tput setaf 2)#   |  _  /| |  | |  _  /    \ \/  \/ / _ \| '__| |/ |  _| |/ _ \ \ /\ / /
$(tput setaf 2)#   | | \ \| |__| | | \ \     \  /\  | (_) | |  |   <| | | | (_) \ V  V /
$(tput setaf 2)#   |_|  \_\\____/|_|  \_\     \/  \/ \___/|_|  |_|\_|_| |_|\___/ \_/\_/
"

#==================================
#
#        If App Name is Defined
#            $1: App Name
#
#==================================#
if [ ! -z "$1" ]; then

    echo "
    # ###########################
    #                           #
    #                           #
    #                           #
    #      1 - Installation     #
    #                           #
    #                           #
    #                           #
    # ###########################
    "
    # Create and Enter to the Folder of the new app
    mkdir projects/$1
    cd projects/$1

    # Copy the Gemfile and .gitignore to the application folder
    cp ../../templates/Gemfile ../../templates/.gitignore .

    # Install Bundles
    bundle install

    # Create the New APP
    bundle exec rails new . -d mysql --webpack --skip-git --skip-gemfile --skip-test

    # Create a Database
    bundle exec rake db:create

    # Install Rspec
    bundle exec rails generate rspec:install

    # Install Cucumber
    bundle exec rails generate cucumber:install

    # Install Devise, plus generate the Views and the Migration
    bundle exec rails generate devise:install
    bundle exec rails generate devise:views
    bundle exec rails generate devise User

    # Home Controller
    bundle exec rails generate controller home index --no-helper --no-assets --no-controller-specs --no-view-specs

    # Add Devise and Home routes
    cp ../../templates/config/routes.rb config/

    # Rspec Config File
    echo "'rails_helper.rb' will be modified with the new version"
    cp ../../templates/spec/rails_helper.rb spec/

    # Factory Girl
    mkdir spec/factories
    cp ../../templates/spec/factories/users.rb spec/factories/

    # Guard
    bundle exec guard init rspec

    # Install Yarn Dependencies
    cp ../../templates/package.json .
    sed "s/my-app/$1/" package.json > package2.json
    rm package.json
    mv package2.json package.json

    yarn install

    #
    #
    #
    # Webpack
    cp -R ../../templates/config/webpack config/

    #
    #
    #
    # JS
    rm -r app/assets/javascripts app/assets/config
    cp -R ../../templates/app/javascript/packs/js app/javascript/packs/
    cp -R ../../templates/app/javascript/packs/application.js app/javascript/packs/


    #
    #
    #
    # CSS
    rm app/assets/stylesheets/application.css
    cp -R ../../templates/app/javascript/packs/css app/javascript/packs/
    cp -R ../../templates/app/javascript/packs/application.scss app/javascript/packs/

    # Copy View Files
    cp ../../templates/app/views/layouts/* app/views/layouts/

    # Change the Application Title
    sed "s/myApp/$1/" app/views/layouts/application.html.erb > app/views/layouts/application.html.erb2
    rm app/views/layouts/application.html.erb2
    mv app/views/layouts/application.html.erb2 app/views/layouts/application.html.erb

    # Update ReadMe
    rm README.md
    echo "# $1" > README.md

    # Set the Environment to development
    bundle exec rails db:environment:set RAILS_ENV=development

    # Create and Migrate the Database
    bundle exec rake db:migrate RAILS_ENV=development

    echo "
    # ###########################
    #                           #
    #                           #
    #                           #
    #         Deployment        #
    #                           #
    #                           #
    #                           #
    # ###########################
    "
    # Login
    heroku login

    # Create an app with the same name as the project name
    heroku apps:create sinjapp-$1

    # Select the app
    heroku git:remote -a sinjapp-$1

    # Attaching cleardb to the app
    heroku addons:create cleardb:ignite

    # Set the new cleardb database URL
    DATABASE_URL=$(heroku config | grep CLEARDB_DATABASE_URL)
    ORIGINAL_NAME="CLEARDB_DATABASE_URL: mysql"
    NEW_NAME="mysql2"
    DATABASE_NEW_URL=${DATABASE_URL//$ORIGINAL_NAME/$NEW_NAME}
    heroku config:set DATABASE_URL=$DATABASE_NEW_URL

    # Create a New Github Repository
    tput setaf 2;
    echo "\n\nCreate a New Github Repository with the name $1"

    # Github Repository Confirmation
    read -p "$(tput setaf 9)Did you already create a new repository with the name $(tput setaf 2)'$1' $(tput setaf 9)on Github? (y/n) " -n 1

    #
    #
    # If the github repository is created
    if [[ $REPLY =~ ^[Yy]$ ]]; then

        # Init, Add, Commit and Push Project Files
        git init
        git add -A
        git remote add origin https://github.com/Clarkom/$1.git
        git commit -m "Hello World"
        git push -u origin master

        tput setaf 2;
        echo "
        # ###########################
        #                           #
        #                           #
        #                           #
        #          The End          #
        #                           #
        #                           #
        #                           #
        # ###########################
        "
        tput setaf 2; echo "✔ - Successful Installation \n"

        # Connect the heroku App to github
        tput setaf 9;echo "Connect the Heroku App $(tput setaf 2)'sinjapp-$1' $(tput setaf 9)to the $(tput setaf 2)'$1' $(tput setaf 9)Github Repository from the link above:"
        tput setaf 5;echo "https://dashboard.heroku.com/apps/sinjapp-$1/deploy/github\n"

        # Commands to run locally
        tput setaf 9;echo "+ Database Migration Command:"
        tput setaf 5; echo "→ heroku run rake db:migrate\n"

        tput setaf 9;echo "+ Local Server Commands:"
        tput setaf 5; echo "→ cd project/$1"
        tput setaf 5; echo "→ rails server"
        tput setaf 5; echo "→ yarn dev_server"
        tput setaf 5; echo "→ rails console"
    fi



#==================================
#
#     If App Name isn't Defined
#
#==================================#
else
    tput setaf 7; echo "Notice:"
    tput setaf 1; echo " + You need to set the app name example: $(tput setaf 7)'./ror-workflow.sh app_name' \n"

fi


