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

    sudo rm -r $1
    mkdir $1
    cd $1
    cp ../templates/* .
    bundle install
    rails new . -d mysql --webpack --skip-git --skip-gemfile --skip-test
    bin/rails db:environment:set RAILS_ENV=development
    rails generate rspec:install
    rails generate devise:install
    rails generate devise:views
    rails generate devise User
    bin/rails db:drop db:create db:migrate RAILS_ENV=developmen
    rails generate controller home index --no-helper --no-assets --no-controller-specs --no-view-specs

    #
    #
    # Devise Config
    echo "\n\n1 + Add these two lines to config/routes.rb"
    echo "root to: 'home#index'"
    echo "devise_for :users\n"
    #
    echo "2 + Add this line to 'config/environments/development.rb' "
    echo "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n"
    #
    echo "3 + Optional: Add this line to application_controller.rb"
    echo "before_action :authenticate_user! \n"
    #
    echo "4 + "

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


