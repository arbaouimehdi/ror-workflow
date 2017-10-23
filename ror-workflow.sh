#!/bin/sh

echo "
#    _____   ____  _____   __          __        _     __ _
#   |  __ \ / __ \|  __ \  \ \        / /       | |   / _| |
#   | |__) | |  | | |__) |  \ \  /\  / ___  _ __| | _| |_| | _____      __
#   |  _  /| |  | |  _  /    \ \/  \/ / _ \| '__| |/ |  _| |/ _ \ \ /\ / /
#   | | \ \| |__| | | \ \     \  /\  | (_) | |  |   <| | | | (_) \ V  V /
#   |_|  \_\\____/|_|  \_\     \/  \/ \___/|_|  |_|\_|_| |_|\___/ \_/\_/"

#==================================
#
#        If App Name is Defined
#            $1: App Name
#
#==================================#
if [ ! -z "$1" ]; then

echo "
# ############################
#                            #
#                            #
#                            #
#      1 - Installation      #
#                            #
#                            #
#                            #
# ############################"
                                                                              # The Begining
mkdir projects/$1                                                             # 0 - Finish
cd projects/$1                                                                # 1 - Finish
cp ../../templates/Gemfile ../../templates/.gitignore .                       # 1 - Copy the Gemfile and .gitignore to the application folder
bundle install                                                                # 2 - Install Bundles
rails new . -d mysql --webpack --skip-git --skip-gemfile --skip-test          # 3 - Create the New APP
cp ../../templates/config/webpacker.yml config/                               # 4 - Copy webpacker.yml
rake db:create                                                                # 5 - Create a Database
sudo pkill -9 rails && sudo pkill -9 spring && spring stop                    # 6 - 
rails generate rspec:install                                                  # 8 - Install Rspec
rails generate cucumber:install                                               # 9 - Install Cucumber
rails generate devise:install                                                 # 10 - Install Devise, plus generate the Views and the Migration
rails generate devise:views                                                   # 11
rails generate devise User                                                    # 12
rails generate controller home index \
--no-helper --no-assets --no-controller-specs --no-view-specs                 # 13 - Generate a Home Controller
cp ../../templates/config/routes.rb config/                                   # 14 - Add Devise and Home routes
echo "'rails_helper.rb' will be modified with the new version"                # 15 -
cp ../../templates/spec/rails_helper.rb spec/                                 # 16 -
mkdir spec/factories                                                          # 17 -
cp ../../templates/spec/factories/users.rb spec/factories/                    # 18 -
guard init rspec                                                              # 19 -
cp ../../templates/package.json .                                             # 20 -
sed "s/my-app/$1/" package.json > package2.json                               # 21 -
rm package.json                                                               # 22 -
mv package2.json package.json                                                 # 23 -
yarn install
cp -R ../../templates/config/webpack config/                                  # 23 -
rm -r app/assets/config app/javascript                                        # 24 -
cp -r ../../templates/app/javascript app/                                     # 25 -
cp -r ../../templates/app/assets/javascripts/ app/assets/                     # 26 -
rm app/assets/stylesheets/application.css                                     # 27 -
cp -r ../../templates/app/assets/stylesheets/ app/assets/                     # 28 -
cp ../../templates/app/views/layouts/* app/views/layouts/                     # 29 -
sed "s/myApp/$1/" app/views/layouts/application.html.erb >\
app/views/layouts/application.html.erb2
rm app/views/layouts/application.html.erb2                                    # 30 -
mv app/views/layouts/application.html.erb2\
app/views/layouts/application.html.erb
rm README.md                                                                  # 31 -
echo "# $1" > README.md                                                       # 32 -
rails db:environment:set RAILS_ENV=development                                # 33 -
rake db:migrate RAILS_ENV=development                                         # 34 -

echo "
# ###########################
#                           #
#                           #
#                           #
#       2- Deployment       #
#                           #
#                           #
#                           #
# ###########################
"

heroku login                                                                 # 35 - Heroku Login
heroku apps:create sinjapp-$1                                                # 36 - Create a Heroku Application
heroku git:remote -a sinjapp-$1                                              # 37 - Select the Application
heroku addons:create cleardb:ignite                                          # 38 - Attach cleardb to the Application
DATABASE_URL=$(heroku config | grep CLEARDB_DATABASE_URL)                    # 39 - Set the new cleardb database URL
ORIGINAL_NAME="CLEARDB_DATABASE_URL: mysql"                                  # 40 -
NEW_NAME="mysql2"                                                            # 41 -
DATABASE_NEW_URL=${DATABASE_URL//$ORIGINAL_NAME/$NEW_NAME}                   # 42 -
heroku config:set DATABASE_URL=$DATABASE_NEW_URL                             # 43 -
echo "\n\nCreate a New Github Repository with the name $1"                   # 44 -
read -p "Did '$1' exisit on your Github repositories? (y/n) " -n 1           # 45 -

#
#
#
#
# If the github repository is created
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git init                                                                # 46 -
    git add -A                                                              # 47 -
    git remote add origin https://github.com/Clarkom/$1.git                 # 48 -
    git commit -m "Hello World"                                             # 49 -
    git push -u origin master                                               # 50 -
                                                                            # The End
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
    echo "✔ - Successful Installation \n"
    echo "Connect the Heroku App 'sinjapp-$1' to the '$1' Github Repository:"
    echo "https://dashboard.heroku.com/apps/sinjapp-$1/deploy/github\n"
    echo "+ Database Migration Command:"
    echo "→ heroku run rake db:migrate\n"
    echo "+ Local Server Commands:"
    echo "→ cd projects/$1"
    echo "→ rails server"
    echo "→ yarn dev_server"
    echo "→ rails console"
fi

#==================================
#
#     If App Name isn't Defined
#
#==================================#
else
    echo "Notice:"
    echo " + You need to set the app name example: './ror-workflow.sh app_name' \n"
fi


