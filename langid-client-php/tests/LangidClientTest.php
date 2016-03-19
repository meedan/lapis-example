<?php
namespace Meedan\LangidClient;

class LangidClientTest extends \PHPUnit_Framework_TestCase {

  public function test_languages_classify_returns_text_language() {
    $res = LangidClient::mock_languages_classify_returns_text_language();
    $this->assertEquals("error", $res->type);
    $this->assertEquals("Unauthorized", $res->data->message);
    $this->assertEquals(1, $res->data->code);
  }
  public function test_languages_classify_returns_parameter_text_is_missing() {
    $res = LangidClient::mock_languages_classify_returns_parameter_text_is_missing();
    $this->assertEquals("error", $res->type);
    $this->assertEquals("Unauthorized", $res->data->message);
    $this->assertEquals(1, $res->data->code);
  }
  public function test_languages_classify_returns_access_denied() {
    $res = LangidClient::mock_languages_classify_returns_access_denied();
    $this->assertEquals("error", $res->type);
    $this->assertEquals("Unauthorized", $res->data->message);
    $this->assertEquals(1, $res->data->code);
  }
}
