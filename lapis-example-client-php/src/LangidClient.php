<?php
namespace Meedan\LangidClient;

class LangidClient extends \Meedan\Lapis\LapisClient {

  function __construct($config = []) {
    $config['token_name'] = 'X-Lapis-Token';
    parent::__construct($config);
  }
  
  // GET /api/languages/classify
  // Send some text to be classified
  // @param $text
  //  Text to be classified
  public function get_languages_classify($text) {
    return $this->request('get', '/api/languages/classify', [ 'text' => $text ]);
  }
  
  public static function mock_languages_classify_returns_text_language() {
    $c = new LangidClient(['token_value' => 'test', 'client' => self::createMockClient(
      200, json_decode("{\"type\":\"error\",\"data\":{\"message\":\"Unauthorized\",\"code\":1}}", true)
    )]);
    return $c->get_languages_classify("The book is on the table");
  }
  public static function mock_languages_classify_returns_parameter_text_is_missing() {
    $c = new LangidClient(['token_value' => 'test', 'client' => self::createMockClient(
      400, json_decode("{\"type\":\"error\",\"data\":{\"message\":\"Unauthorized\",\"code\":1}}", true)
    )]);
    return $c->get_languages_classify('');
  }
  public static function mock_languages_classify_returns_access_denied() {
    $c = new LangidClient(['token_value' => '', 'client' => self::createMockClient(
      401, json_decode("{\"type\":\"error\",\"data\":{\"message\":\"Unauthorized\",\"code\":1}}", true)
    )]);
    return $c->get_languages_classify("Test");
  }
}
