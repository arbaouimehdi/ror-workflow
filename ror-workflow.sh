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
mkdir projects/$1                                                             # -
cd projects/$1                                                                # -
cp ../../templates/Gemfile ../../templates/.gitignore .                       # - Copy the Gemfile and .gitignore to the application folder
bundle install                                                                # - Install Bundles
bundle exec rails new . -d mysql --webpack --skip-git \
--skip-gemfile --skip-test                                                    # - Create the New APP
cp ../../templates/config/webpacker.yml config/                               # - Copy webpacker.yml
rake db:create                                                                # - Create a Database
bundle exec rails generate rspec:install                                      # - Install Rspec
bundle exec rails generate cucumber:install                                   # - Install Cucumber
bundle exec rails generate devise:install                                     # - Install Devise, plus generate the Views and the Migration
bundle exec rails generate devise:views                                       # -
bundle exec rails generate devise User                                        # -
bundle exec rails generate controller home index\
 --no-helper --no-assets --no-controller-specs --no-view-specs
cp ../../templates/config/routes.rb config/                                   # - Add Devise and Home routes
echo "'rails_helper.rb' will be modified with the new version"                # -
cp ../../templates/spec/rails_helper.rb spec/                                 # -
mkdir spec/factories                                                          # -
cp ../../templates/spec/factories/users.rb spec/factories/                    # -
guard init rspec                                                              # -

echo "
# ###########################
#                           #
#           Webpack         #
#                           #
# ###########################
"
cp ../../templates/package.json .                                             # -
sed "s/my-app/$1/" package.json > package2.json                               # -
rm package.json                                                               # -
mv package2.json package.json                                                 # -
yarn install
cp -R ../../templates/config/webpack config/                                  # -
rm -r app/assets app/javascript
cp -r ../../templates/app/javascript app/                                     # -
cp -r ../../templates/app/assets app/                                         # -
cp ../../templates/app/views/layouts/* app/views/layouts/                     # -

echo "
# ###########################
#                           #
#                           #
#                           #
#       3- HTML Views       #
#                           #
#                           #
#                           #
# ###########################
"
sed "s/myApp/$1/" app/views/layouts/application.html.erb >\
app/views/layouts/application.html.erb2
rm app/views/layouts/application.html.erb2
mv app/views/layouts/application.html.erb2\
app/views/layouts/application.html.erb

echo "
# ###########################
#                           #
#      Admin Dashboard      #
#                           #
# ###########################
"


rm README.md                                                                  # -
echo "# $1" > README.md                                                       # -
rails db:environment:set RAILS_ENV=development                                # -
rake db:migrate RAILS_ENV=development                                         # -

echo "
# ###########################
#                           #
#                           #
#                           #
#       4- Deployment       #
#                           #
#                           #
#                           #
# ###########################
"
heroku login                                                                 # - Heroku Login
heroku apps:create sinjapp-$1                                                # - Create a Heroku Application
heroku git:remote -a sinjapp-$1                                              # - Select the Application
heroku addons:create cleardb:ignite                                          # - Attach cleardb to the Application
DATABASE_URL=$(heroku config | grep CLEARDB_DATABASE_URL)                    # - Set the new cleardb database URL
ORIGINAL_NAME="CLEARDB_DATABASE_URL: mysql"                                  # -
NEW_NAME="mysql2"                                                            # -
DATABASE_NEW_URL=${DATABASE_URL//$ORIGINAL_NAME/$NEW_NAME}                   # -
heroku config:set DATABASE_URL=$DATABASE_NEW_URL                             # -
echo "\n\nCreate a New Github Repository with the name $1"                   # -
read -p "Did '$1' exist on your Github repositories? (y/n) " -n 1           # -

#
#
#
#
# If the github repository is created
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git init                                                                # -
    git add -A                                                              # -
    git remote add origin https://github.com/Clarkom/$1.git                 # -
    git commit -m "Hello World"                                             # -
    git push -u origin master                                               # -
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


