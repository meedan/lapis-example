## Lapis Example

This is a sample API written on top of [Lapis](https://github.com/meedan/lapis).

It's an API with a single endpoint that, given a text, returns its language, using [WhatLanguage](https://github.com/peterc/whatlanguage).

In order to play with this API, do the following:

* Configure `config/config.yml`, `config/database.yml`, `config/initializers/errbit.rb` and `config/initializers/secret_token.rb`
* Run `rake db:migrate`
* Create an API key: `rake lapis:api_keys:create`
* Start the server: `rails s`
* Go to `http://localhost:3000/api` and use the API key you created
