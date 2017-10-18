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

    #sudo rm -r $1
    #mkdir $1
    #cd $1
    #cp ../templates/* .
    #bundle install
    #rails new . -d mysql --webpack --skip-git --skip-gemfile --skip-test
    bin/rails db:environment:set RAILS_ENV=development
    #bundle exec rake db:create
    #rails generate rspec:install
    #rails generate devise:install
    #rails generate devise:views
    rails generate devise User
    bundle exec rake db:migrate

    #
    #
    # Devise Config
    clear
    echo "\n\n1 + Add this line to config/routes.rb"
    echo "root to: 'home#index'\n"
    #
    echo "2 + Add this line to 'config/environments/development.rb' "
    echo "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n"
    #
    echo "3 + Optional: Add this line to application_controller.rb"
    echo "before_action :authenticate_user! \n"

    read -p "next step? (y/n) " -n 1
    echo "Good Bye"
     
    #
    # If Devise is configured
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Yep"    
    fi

else
    echo " + You need to set the app name 'example: ./run.sh app_name' \n"

fi


