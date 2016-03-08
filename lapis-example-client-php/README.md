
  # LangidClient

  This package is a PHP client for langid, which defines itself as 'An application to be used as an example for Lapis framework'. It also provides mock methods to test it.

  ## Installation

  Add this line to your application's `composer.json` `require` dependencies:

  ```php
  "meedan/langid-client": "*"
  ```

  And then execute:

      $ composer install

  Or install it yourself as:

      $ composer install langid_client

  ## Usage

  With this package you can call methods from langid's API and also test them by using the provided mocks.

  The available methods are:

  * LangidClient::get_languages_classify (`GET /api/languages/classify`)

  If you are going to test something that uses the 'langid' service, first you need to mock each possible response it can return, which are:

  * LangidClient::mock_languages_classify_returns_text_language
* LangidClient::mock_languages_classify_returns_parameter_text_is_missing
* LangidClient::mock_languages_classify_returns_access_denied

  ## Contributing

  1. Fork it
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request
      
