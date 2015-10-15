## API Base Sample

This is a sample API written on top of [Meedan's API Base](https://github.com/meedan/api-base).

It's an API with a single endpoint that, given a text, returns its language, using [WhatLanguage](https://github.com/peterc/whatlanguage).

The first two commits were made automatically by the generator. The [third commit](https://github.com/meedan/api-base-example/commit/c13f146327dc1647b5c62a670c037e39e7ab67c3) is the one that really contains this API's code. Finally, the fourth commit adds the documentation generated automatically by doing `cd doc/ && make`.

In order to play with this API, do the following:

* Configure `config/config.yml`, `config/database.yml`, `config/initializers/errbit.rb` and `config/initializers/secret_token.rb`
* Run `rake db:migrate`
* Create an API key: `rake meedan:api_key:create`
* Start the server: `rails server`
* Go to `http://localhost:3000/api` and use the API key you created
