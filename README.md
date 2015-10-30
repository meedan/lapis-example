## Lapis Example

This is a sample API written on top of [Lapis](https://github.com/meedan/lapis).

It's an API with a single endpoint that, given a text, returns its language, using [WhatLanguage](https://github.com/peterc/whatlanguage).

In order to play with this API, do the following:

* Configure `config/config.yml`, `config/database.yml`, `config/initializers/errbit.rb` and `config/initializers/secret_token.rb`
* Run `rake db:migrate`
* Create an API key: `rake lapis:api_keys:create`
* Start the server: `rails s`
* Go to `http://localhost:3000/api` and use the API key you created
* You can also start the application on Docker by running `./docker/run.sh` (it will run on port 80 and your local hostname) - you first need to create an API key after entering the container (`./docker/shell.sh`)

Other applications can communicate with this service (and test this communication) using [lapis-example-client](https://github.com/meedan/lapis-example-client), which is a gem generated automatically with `rake lapis:build_client_gem`, a rake task provided by Lapis.
