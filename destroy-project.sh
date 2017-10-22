#!/bin/sh

echo "
$(tput setaf 2)#    _____   ____  _____   __          __        _     __ _
$(tput setaf 2)#   |  __ \ / __ \|  __ \  \ \        / /       | |   / _| |
$(tput setaf 2)#   | |__) | |  | | |__) |  \ \  /\  / ___  _ __| | _| |_| | _____      __
$(tput setaf 2)#   |  _  /| |  | |  _  /    \ \/  \/ / _ \| '__| |/ |  _| |/ _ \ \ /\ / /
$(tput setaf 2)#   | | \ \| |__| | | \ \     \  /\  | (_) | |  |   <| | | | (_) \ V  V /
$(tput setaf 2)#   |_|  \_\\____/|_|  \_\     \/  \/ \___/|_|  |_|\_|_| |_|\___/ \_/\_/
"

#
#
# Destroying the Project Confirmation
read -p "$(tput setaf 1)Do you really want to Destroy $(tput setaf 7)'$1' $(tput setaf 1)project Locally and From Heruko (y/n)" -n 1

#
#
#
if [[ $REPLY =~ ^[Yy]$ ]]; then

    tput setaf 2;
    echo "
    # ##################################
    #                                  #
    #    Remove the Project Folder     #
    #      & the Database Locally      #
    #                                  #
    # ##################################
    "
    # Enter to the Project Folder
    cd projects/$1

    # Remove the database
    rake db:drop > /dev/null
    echo "✔ - Database removed"

    # Remove the project Folder
    cd ..
    rm -r $1 > /dev/null
    echo "✔ - Project folder projects/$1 removed"


    echo "
    # ##################################
    #                                  #
    #         Remove Heroku App        #
    #                                  #
    # ##################################
    "
    tput setaf 7;
    heroku login
    heroku git:remote -a sinjapp-$1
    heroku apps:destroy
    tput setaf 2;
    echo "✔ - Heroku app: $(tput setaf 9)sinjapp-$1 $(tput setaf 2)removed"


    echo "
    # ##################################
    #                                  #
    #   Remove the Github Repository   #
    #                                  #
    # ##################################
    "
    tput setaf 7;
    read -p "Did you remove $1 from Github? (y/n) " -n 1

    #
    #
    # If the github repository is created
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        tput setaf 2;
        echo "✔ - Github Repository $1 removed\n\n"
        echo "✔ - $1 Completely Destroyed $(tput setaf 9) Locally $(tput setaf 2)and from $(tput setaf 9)Heroku"
    fi



fi

