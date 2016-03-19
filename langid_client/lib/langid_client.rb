require 'langid_client/version'
require 'webmock'
require 'net/http'
module LangidClient
  include WebMock::API

  @host = nil

  def self.host=(host)
    @host = host
  end

  def self.host
    @host
  end

  module Request
    
    # GET /api/languages/classify
    def self.get_languages_classify(host = nil, params = {}, token = '', headers = {})
      request('get', host, '/api/languages/classify', params, token, headers)
    end
           
    private

    def self.request(method, host, path, params = {}, token = '', headers = {})
      host ||= LangidClient.host
      uri = URI(host + path)
      klass = 'Net::HTTP::' + method.capitalize
      request = nil

      if method == 'get'
        querystr = params.reject{ |k, v| v.blank? }.collect{ |k, v| k.to_s + '=' + CGI::escape(v.to_s) }.reverse.join('&')
        (querystr = '?' + querystr) unless querystr.blank?
        request = klass.constantize.new(uri.path + querystr)
      elsif method == 'post'
        request = klass.constantize.new(uri.path)
        request.set_form_data(params)
      end

      unless token.blank?
        request['X-Lapis-Token'] = token.to_s
      end

      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = uri.scheme == 'https'
      response = http.request(request)
      if response.code.to_i === 401
        raise 'Unauthorized'
      else
        JSON.parse(response.body)
      end
    end
  end

  module Mock
    
    def self.mock_languages_classify_returns_text_language(host = nil)
      WebMock.disable_net_connect!
      host ||= LangidClient.host
      WebMock.stub_request(:get, host + '/api/languages/classify')
      .with({:query=>{:text=>"The book is on the table"}, :headers=>{"X-Lapis-Token"=>"test"}})
      .to_return(body: '{"type":"language","data":"english"}', status: 200)
      @data = {"type"=>"language", "data"=>"english"}
      yield
      WebMock.allow_net_connect!
    end
             
    def self.mock_languages_classify_returns_parameter_text_is_missing(host = nil)
      WebMock.disable_net_connect!
      host ||= LangidClient.host
      WebMock.stub_request(:get, host + '/api/languages/classify')
      .with({:query=>nil, :headers=>{"X-Lapis-Token"=>"test"}})
      .to_return(body: '<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>Action Controller: Exception caught</title>
  <style>
    body {
      background-color: #FAFAFA;
      color: #333;
      margin: 0px;
    }

    body, p, ol, ul, td {
      font-family: helvetica, verdana, arial, sans-serif;
      font-size:   13px;
      line-height: 18px;
    }

    pre {
      font-size: 11px;
      white-space: pre-wrap;
    }

    pre.box {
      border: 1px solid #EEE;
      padding: 10px;
      margin: 0px;
      width: 958px;
    }

    header {
      color: #F0F0F0;
      background: #C52F24;
      padding: 0.5em 1.5em;
    }

    h1 {
      margin: 0.2em 0;
      line-height: 1.1em;
      font-size: 2em;
    }

    h2 {
      color: #C52F24;
      line-height: 25px;
    }

    .details {
      border: 1px solid #D0D0D0;
      border-radius: 4px;
      margin: 1em 0px;
      display: block;
      width: 978px;
    }

    .summary {
      padding: 8px 15px;
      border-bottom: 1px solid #D0D0D0;
      display: block;
    }

    .details pre {
      margin: 5px;
      border: none;
    }

    #container {
      box-sizing: border-box;
      width: 100%;
      padding: 0 1.5em;
    }

    .source * {
      margin: 0px;
      padding: 0px;
    }

    .source {
      border: 1px solid #D9D9D9;
      background: #ECECEC;
      width: 978px;
    }

    .source pre {
      padding: 10px 0px;
      border: none;
    }

    .source .data {
      font-size: 80%;
      overflow: auto;
      background-color: #FFF;
    }

    .info {
      padding: 0.5em;
    }

    .source .data .line_numbers {
      background-color: #ECECEC;
      color: #AAA;
      padding: 1em .5em;
      border-right: 1px solid #DDD;
      text-align: right;
    }

    .line {
      padding-left: 10px;
    }

    .line:hover {
      background-color: #F6F6F6;
    }

    .line.active {
      background-color: #FFCCCC;
    }

    .hidden {
      display: none;
    }

    a { color: #980905; }
    a:visited { color: #666; }
    a.trace-frames { color: #666; }
    a:hover { color: #C52F24; }
    a.trace-frames.selected { color: #C52F24 }

    
  </style>

  <script>
    var toggle = function(id) {
      var s = document.getElementById(id).style;
      s.display = s.display == 'none' ? 'block' : 'none';
      return false;
    }
    var show = function(id) {
      document.getElementById(id).style.display = 'block';
    }
    var hide = function(id) {
      document.getElementById(id).style.display = 'none';
    }
    var toggleTrace = function() {
      return toggle('blame_trace');
    }
    var toggleSessionDump = function() {
      return toggle('session_dump');
    }
    var toggleEnvDump = function() {
      return toggle('env_dump');
    }
  </script>
</head>
<body>

<header>
  <h1>
    NameError
      in Api::V1::LanguagesController#classify
  </h1>
</header>

<div id="container">
  <h2>undefined local variable or method `render_parameters_missing&#39; for #&lt;Api::V1::LanguagesController:0x00000000c68ef0&gt;</h2>

      <div class="source " id="frame-source-0">
      <div class="info">
        Extracted source (around line <strong>#8</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>6</span>
<span>7</span>
<span>8</span>
<span>9</span>
<span>10</span>
<span>11</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    wl = WhatLanguage.new(:english, :german, :french, :spanish, :portuguese)
</div><div class="line">    if params[:text].blank?
</div><div class="line active">      render_parameters_missing
</div><div class="line">    else
</div><div class="line">      @language = wl.language(params[:text].to_s)
</div><div class="line">      render_success &#39;language&#39;, @language
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-1">
      <div class="info">
        Extracted source (around line <strong>#4</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>2</span>
<span>3</span>
<span>4</span>
<span>5</span>
<span>6</span>
<span>7</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">  module ImplicitRender
</div><div class="line">    def send_action(method, *args)
</div><div class="line active">      ret = super
</div><div class="line">      default_render unless performed?
</div><div class="line">      ret
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-2">
      <div class="info">
        Extracted source (around line <strong>#198</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>196</span>
<span>197</span>
<span>198</span>
<span>199</span>
<span>200</span>
<span>201</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      # which is *not* necessarily the same as the action name.
</div><div class="line">      def process_action(method_name, *args)
</div><div class="line active">        send_action(method_name, *args)
</div><div class="line">      end
</div><div class="line">
</div><div class="line">      # Actually call the method associated with the action. Override
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-3">
      <div class="info">
        Extracted source (around line <strong>#10</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>8</span>
<span>9</span>
<span>10</span>
<span>11</span>
<span>12</span>
<span>13</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def process_action(*) #:nodoc:
</div><div class="line">      self.formats = request.formats.map(&amp;:ref).compact
</div><div class="line active">      super
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    # Check for double render errors and set the content_type after rendering.
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-4">
      <div class="info">
        Extracted source (around line <strong>#20</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
<span>22</span>
<span>23</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def process_action(*args)
</div><div class="line">      run_callbacks(:process_action) do
</div><div class="line active">        super
</div><div class="line">      end
</div><div class="line">    end
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-5">
      <div class="info">
        Extracted source (around line <strong>#117</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>115</span>
<span>116</span>
<span>117</span>
<span>118</span>
<span>119</span>
<span>120</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        def call(env)
</div><div class="line">          block = env.run_block
</div><div class="line active">          env.value = !env.halted &amp;&amp; (!block || block.call)
</div><div class="line">          env
</div><div class="line">        end
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-6">
      <div class="info">
        Extracted source (around line <strong>#117</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>115</span>
<span>116</span>
<span>117</span>
<span>118</span>
<span>119</span>
<span>120</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        def call(env)
</div><div class="line">          block = env.run_block
</div><div class="line active">          env.value = !env.halted &amp;&amp; (!block || block.call)
</div><div class="line">          env
</div><div class="line">        end
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-7">
      <div class="info">
        Extracted source (around line <strong>#555</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>553</span>
<span>554</span>
<span>555</span>
<span>556</span>
<span>557</span>
<span>558</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def compile
</div><div class="line">        @callbacks || @mutex.synchronize do
</div><div class="line active">          final_sequence = CallbackSequence.new { |env| Filters::ENDING.call(env) }
</div><div class="line">          @callbacks ||= @chain.reverse.inject(final_sequence) do |callback_sequence, callback|
</div><div class="line">            callback.apply callback_sequence
</div><div class="line">          end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-8">
      <div class="info">
        Extracted source (around line <strong>#505</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>503</span>
<span>504</span>
<span>505</span>
<span>506</span>
<span>507</span>
<span>508</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def call(*args)
</div><div class="line">        @before.each { |b| b.call(*args) }
</div><div class="line active">        value = @call.call(*args)
</div><div class="line">        @after.each { |a| a.call(*args) }
</div><div class="line">        value
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-9">
      <div class="info">
        Extracted source (around line <strong>#505</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>503</span>
<span>504</span>
<span>505</span>
<span>506</span>
<span>507</span>
<span>508</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def call(*args)
</div><div class="line">        @before.each { |b| b.call(*args) }
</div><div class="line active">        value = @call.call(*args)
</div><div class="line">        @after.each { |a| a.call(*args) }
</div><div class="line">        value
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-10">
      <div class="info">
        Extracted source (around line <strong>#92</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>90</span>
<span>91</span>
<span>92</span>
<span>93</span>
<span>94</span>
<span>95</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        runner = callbacks.compile
</div><div class="line">        e = Filters::Environment.new(self, false, nil, block)
</div><div class="line active">        runner.call(e).value
</div><div class="line">      end
</div><div class="line">    end
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-11">
      <div class="info">
        Extracted source (around line <strong>#778</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>776</span>
<span>777</span>
<span>778</span>
<span>779</span>
<span>780</span>
<span>781</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          module_eval &lt;&lt;-RUBY, __FILE__, __LINE__ + 1
</div><div class="line">            def _run_#{name}_callbacks(&amp;block)
</div><div class="line active">              __run_callbacks__(_#{name}_callbacks, &amp;block)
</div><div class="line">            end
</div><div class="line">          RUBY
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-12">
      <div class="info">
        Extracted source (around line <strong>#81</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>79</span>
<span>80</span>
<span>81</span>
<span>82</span>
<span>83</span>
<span>84</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    #   end
</div><div class="line">    def run_callbacks(kind, &amp;block)
</div><div class="line active">      send &quot;_run_#{kind}_callbacks&quot;, &amp;block
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    private
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-13">
      <div class="info">
        Extracted source (around line <strong>#19</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
<span>22</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    # process_action callbacks around the normal behavior.
</div><div class="line">    def process_action(*args)
</div><div class="line active">      run_callbacks(:process_action) do
</div><div class="line">        super
</div><div class="line">      end
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-14">
      <div class="info">
        Extracted source (around line <strong>#29</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>27</span>
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    private
</div><div class="line">      def process_action(*args)
</div><div class="line active">        super
</div><div class="line">      rescue Exception =&gt; exception
</div><div class="line">        request.env[&#39;action_dispatch.show_detailed_exceptions&#39;] ||= show_detailed_exceptions?
</div><div class="line">        rescue_with_handler(exception) || raise(exception)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-15">
      <div class="info">
        Extracted source (around line <strong>#32</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
<span>34</span>
<span>35</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      ActiveSupport::Notifications.instrument(&quot;process_action.action_controller&quot;, raw_payload) do |payload|
</div><div class="line">        begin
</div><div class="line active">          result = super
</div><div class="line">          payload[:status] = response.status
</div><div class="line">          result
</div><div class="line">        ensure
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-16">
      <div class="info">
        Extracted source (around line <strong>#164</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>162</span>
<span>163</span>
<span>164</span>
<span>165</span>
<span>166</span>
<span>167</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def instrument(name, payload = {})
</div><div class="line">        if notifier.listening?(name)
</div><div class="line active">          instrumenter.instrument(name, payload) { yield payload if block_given? }
</div><div class="line">        else
</div><div class="line">          yield payload if block_given?
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-17">
      <div class="info">
        Extracted source (around line <strong>#20</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
<span>22</span>
<span>23</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        start name, payload
</div><div class="line">        begin
</div><div class="line active">          yield payload
</div><div class="line">        rescue Exception =&gt; e
</div><div class="line">          payload[:exception] = [e.class.name, e.message]
</div><div class="line">          raise e
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-18">
      <div class="info">
        Extracted source (around line <strong>#164</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>162</span>
<span>163</span>
<span>164</span>
<span>165</span>
<span>166</span>
<span>167</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def instrument(name, payload = {})
</div><div class="line">        if notifier.listening?(name)
</div><div class="line active">          instrumenter.instrument(name, payload) { yield payload if block_given? }
</div><div class="line">        else
</div><div class="line">          yield payload if block_given?
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-19">
      <div class="info">
        Extracted source (around line <strong>#30</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      ActiveSupport::Notifications.instrument(&quot;start_processing.action_controller&quot;, raw_payload.dup)
</div><div class="line">
</div><div class="line active">      ActiveSupport::Notifications.instrument(&quot;process_action.action_controller&quot;, raw_payload) do |payload|
</div><div class="line">        begin
</div><div class="line">          result = super
</div><div class="line">          payload[:status] = response.status
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-20">
      <div class="info">
        Extracted source (around line <strong>#250</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>248</span>
<span>249</span>
<span>250</span>
<span>251</span>
<span>252</span>
<span>253</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        request.filtered_parameters.merge! wrapped_filtered_hash
</div><div class="line">      end
</div><div class="line active">      super
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    private
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-21">
      <div class="info">
        Extracted source (around line <strong>#18</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        # and it won&#39;t be cleaned up by the method below.
</div><div class="line">        ActiveRecord::LogSubscriber.reset_runtime
</div><div class="line active">        super
</div><div class="line">      end
</div><div class="line">
</div><div class="line">      def cleanup_view_runtime
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-22">
      <div class="info">
        Extracted source (around line <strong>#137</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>135</span>
<span>136</span>
<span>137</span>
<span>138</span>
<span>139</span>
<span>140</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      @_response_body = nil
</div><div class="line">
</div><div class="line active">      process_action(action_name, *args)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    # Delegates to the class&#39; #controller_path
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-23">
      <div class="info">
        Extracted source (around line <strong>#30</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def process(*) #:nodoc:
</div><div class="line">      old_config, I18n.config = I18n.config, I18nProxy.new(I18n.config, lookup_context)
</div><div class="line active">      super
</div><div class="line">    ensure
</div><div class="line">      I18n.config = old_config
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-24">
      <div class="info">
        Extracted source (around line <strong>#196</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>194</span>
<span>195</span>
<span>196</span>
<span>197</span>
<span>198</span>
<span>199</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      @_env = request.env
</div><div class="line">      @_env[&#39;action_controller.instance&#39;] = self
</div><div class="line active">      process(name)
</div><div class="line">      to_a
</div><div class="line">    end
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-25">
      <div class="info">
        Extracted source (around line <strong>#13</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>11</span>
<span>12</span>
<span>13</span>
<span>14</span>
<span>15</span>
<span>16</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def dispatch(action, request)
</div><div class="line">      set_response!(request)
</div><div class="line active">      super(action, request)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    def response_body=(body)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-26">
      <div class="info">
        Extracted source (around line <strong>#237</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>235</span>
<span>236</span>
<span>237</span>
<span>238</span>
<span>239</span>
<span>240</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        end
</div><div class="line">      else
</div><div class="line active">        lambda { |env| new.dispatch(name, klass.new(env)) }
</div><div class="line">      end
</div><div class="line">    end
</div><div class="line">  end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-27">
      <div class="info">
        Extracted source (around line <strong>#76</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>74</span>
<span>75</span>
<span>76</span>
<span>77</span>
<span>78</span>
<span>79</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">        def dispatch(controller, action, env)
</div><div class="line active">          controller.action(action).call(env)
</div><div class="line">        end
</div><div class="line">
</div><div class="line">        def normalize_controller!(params)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-28">
      <div class="info">
        Extracted source (around line <strong>#76</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>74</span>
<span>75</span>
<span>76</span>
<span>77</span>
<span>78</span>
<span>79</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">        def dispatch(controller, action, env)
</div><div class="line active">          controller.action(action).call(env)
</div><div class="line">        end
</div><div class="line">
</div><div class="line">        def normalize_controller!(params)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-29">
      <div class="info">
        Extracted source (around line <strong>#45</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>43</span>
<span>44</span>
<span>45</span>
<span>46</span>
<span>47</span>
<span>48</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          end
</div><div class="line">
</div><div class="line active">          dispatch(controller, params[:action], req.env)
</div><div class="line">        end
</div><div class="line">
</div><div class="line">        def prepare_params!(params)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-30">
      <div class="info">
        Extracted source (around line <strong>#49</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>47</span>
<span>48</span>
<span>49</span>
<span>50</span>
<span>51</span>
<span>52</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">          if dispatcher?
</div><div class="line active">            @app.serve req
</div><div class="line">          else
</div><div class="line">            @app.call req.env
</div><div class="line">          end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-31">
      <div class="info">
        Extracted source (around line <strong>#43</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>41</span>
<span>42</span>
<span>43</span>
<span>44</span>
<span>45</span>
<span>46</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          req.path_parameters = set_params.merge parameters
</div><div class="line">
</div><div class="line active">          status, headers, body = route.app.serve(req)
</div><div class="line">
</div><div class="line">          if &#39;pass&#39; == headers[&#39;X-Cascade&#39;]
</div><div class="line">            req.script_name     = script_name
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-32">
      <div class="info">
        Extracted source (around line <strong>#30</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">      def serve(req)
</div><div class="line active">        find_routes(req).each do |match, parameters, route|
</div><div class="line">          set_params  = req.path_parameters
</div><div class="line">          path_info   = req.path_info
</div><div class="line">          script_name = req.script_name
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-33">
      <div class="info">
        Extracted source (around line <strong>#30</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">      def serve(req)
</div><div class="line active">        find_routes(req).each do |match, parameters, route|
</div><div class="line">          set_params  = req.path_parameters
</div><div class="line">          path_info   = req.path_info
</div><div class="line">          script_name = req.script_name
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-34">
      <div class="info">
        Extracted source (around line <strong>#821</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>819</span>
<span>820</span>
<span>821</span>
<span>822</span>
<span>823</span>
<span>824</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        req = request_class.new(env)
</div><div class="line">        req.path_info = Journey::Router::Utils.normalize_path(req.path_info)
</div><div class="line active">        @router.serve(req)
</div><div class="line">      end
</div><div class="line">
</div><div class="line">      def recognize_path(path, environment = {})
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-35">
      <div class="info">
        Extracted source (around line <strong>#24</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>22</span>
<span>23</span>
<span>24</span>
<span>25</span>
<span>26</span>
<span>27</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      status, headers, body = @app.call(env)
</div><div class="line">
</div><div class="line">      if etag_status?(status) &amp;&amp; etag_body?(body) &amp;&amp; !skip_caching?(headers)
</div><div class="line">        original_body = body
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-36">
      <div class="info">
        Extracted source (around line <strong>#25</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>23</span>
<span>24</span>
<span>25</span>
<span>26</span>
<span>27</span>
<span>28</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      case env[REQUEST_METHOD]
</div><div class="line">      when &quot;GET&quot;, &quot;HEAD&quot;
</div><div class="line active">        status, headers, body = @app.call(env)
</div><div class="line">        headers = Utils::HeaderHash.new(headers)
</div><div class="line">        if status == 200 &amp;&amp; fresh?(env, headers)
</div><div class="line">          status = 304
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-37">
      <div class="info">
        Extracted source (around line <strong>#13</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>11</span>
<span>12</span>
<span>13</span>
<span>14</span>
<span>15</span>
<span>16</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">  def call(env)
</div><div class="line active">    status, headers, body = @app.call(env)
</div><div class="line">
</div><div class="line">    if env[REQUEST_METHOD] == HEAD
</div><div class="line">      [
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-38">
      <div class="info">
        Extracted source (around line <strong>#27</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>25</span>
<span>26</span>
<span>27</span>
<span>28</span>
<span>29</span>
<span>30</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      end
</div><div class="line">
</div><div class="line active">      @app.call(env)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    private
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-39">
      <div class="info">
        Extracted source (around line <strong>#260</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>258</span>
<span>259</span>
<span>260</span>
<span>261</span>
<span>262</span>
<span>263</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      @app.call(env)
</div><div class="line">    ensure
</div><div class="line">      session    = Request::Session.find(env) || {}
</div><div class="line">      flash_hash = env[KEY]
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-40">
      <div class="info">
        Extracted source (around line <strong>#225</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>223</span>
<span>224</span>
<span>225</span>
<span>226</span>
<span>227</span>
<span>228</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        def context(env, app=@app)
</div><div class="line">          prepare_session(env)
</div><div class="line active">          status, headers, body = app.call(env)
</div><div class="line">          commit_session(env, status, headers, body)
</div><div class="line">        end
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-41">
      <div class="info">
        Extracted source (around line <strong>#220</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>218</span>
<span>219</span>
<span>220</span>
<span>221</span>
<span>222</span>
<span>223</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">        def call(env)
</div><div class="line active">          context(env)
</div><div class="line">        end
</div><div class="line">
</div><div class="line">        def context(env, app=@app)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-42">
      <div class="info">
        Extracted source (around line <strong>#560</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>558</span>
<span>559</span>
<span>560</span>
<span>561</span>
<span>562</span>
<span>563</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      status, headers, body = @app.call(env)
</div><div class="line">
</div><div class="line">      if cookie_jar = env[&#39;action_dispatch.cookies&#39;]
</div><div class="line">        unless cookie_jar.committed?
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-43">
      <div class="info">
        Extracted source (around line <strong>#36</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>34</span>
<span>35</span>
<span>36</span>
<span>37</span>
<span>38</span>
<span>39</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      connection.enable_query_cache!
</div><div class="line">
</div><div class="line active">      response = @app.call(env)
</div><div class="line">      response[2] = Rack::BodyProxy.new(response[2]) do
</div><div class="line">        restore_query_cache_settings(connection_id, enabled)
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-44">
      <div class="info">
        Extracted source (around line <strong>#653</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>651</span>
<span>652</span>
<span>653</span>
<span>654</span>
<span>655</span>
<span>656</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        testing = env[&#39;rack.test&#39;]
</div><div class="line">
</div><div class="line active">        response = @app.call(env)
</div><div class="line">        response[2] = ::Rack::BodyProxy.new(response[2]) do
</div><div class="line">          ActiveRecord::Base.clear_active_connections! unless testing
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-45">
      <div class="info">
        Extracted source (around line <strong>#377</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>375</span>
<span>376</span>
<span>377</span>
<span>378</span>
<span>379</span>
<span>380</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          end
</div><div class="line">        end
</div><div class="line active">        @app.call(env)
</div><div class="line">      end
</div><div class="line">
</div><div class="line">      private
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-46">
      <div class="info">
        Extracted source (around line <strong>#29</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>27</span>
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      result = run_callbacks :call do
</div><div class="line">        begin
</div><div class="line active">          @app.call(env)
</div><div class="line">        rescue =&gt; error
</div><div class="line">        end
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-47">
      <div class="info">
        Extracted source (around line <strong>#88</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>86</span>
<span>87</span>
<span>88</span>
<span>89</span>
<span>90</span>
<span>91</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def __run_callbacks__(callbacks, &amp;block)
</div><div class="line">      if callbacks.empty?
</div><div class="line active">        yield if block_given?
</div><div class="line">      else
</div><div class="line">        runner = callbacks.compile
</div><div class="line">        e = Filters::Environment.new(self, false, nil, block)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-48">
      <div class="info">
        Extracted source (around line <strong>#778</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>776</span>
<span>777</span>
<span>778</span>
<span>779</span>
<span>780</span>
<span>781</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          module_eval &lt;&lt;-RUBY, __FILE__, __LINE__ + 1
</div><div class="line">            def _run_#{name}_callbacks(&amp;block)
</div><div class="line active">              __run_callbacks__(_#{name}_callbacks, &amp;block)
</div><div class="line">            end
</div><div class="line">          RUBY
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-49">
      <div class="info">
        Extracted source (around line <strong>#81</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>79</span>
<span>80</span>
<span>81</span>
<span>82</span>
<span>83</span>
<span>84</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    #   end
</div><div class="line">    def run_callbacks(kind, &amp;block)
</div><div class="line active">      send &quot;_run_#{kind}_callbacks&quot;, &amp;block
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    private
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-50">
      <div class="info">
        Extracted source (around line <strong>#27</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>25</span>
<span>26</span>
<span>27</span>
<span>28</span>
<span>29</span>
<span>30</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def call(env)
</div><div class="line">      error = nil
</div><div class="line active">      result = run_callbacks :call do
</div><div class="line">        begin
</div><div class="line">          @app.call(env)
</div><div class="line">        rescue =&gt; error
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-51">
      <div class="info">
        Extracted source (around line <strong>#73</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>71</span>
<span>72</span>
<span>73</span>
<span>74</span>
<span>75</span>
<span>76</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      prepare!
</div><div class="line">
</div><div class="line active">      response = @app.call(env)
</div><div class="line">      response[2] = ::Rack::BodyProxy.new(response[2]) { cleanup! }
</div><div class="line">
</div><div class="line">      response
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-52">
      <div class="info">
        Extracted source (around line <strong>#78</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>76</span>
<span>77</span>
<span>78</span>
<span>79</span>
<span>80</span>
<span>81</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def call(env)
</div><div class="line">      env[&quot;action_dispatch.remote_ip&quot;] = GetIp.new(env, self)
</div><div class="line active">      @app.call(env)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    # The GetIp class exists as a way to defer processing of the request data
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-53">
      <div class="info">
        Extracted source (around line <strong>#13</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>11</span>
<span>12</span>
<span>13</span>
<span>14</span>
<span>15</span>
<span>16</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def call(env)
</div><div class="line">        begin
</div><div class="line active">          response = @app.call(env)
</div><div class="line">        rescue Exception =&gt; exception
</div><div class="line">          env[&#39;airbrake.error_id&#39;] = notify_airbrake(env, exception)
</div><div class="line">          raise exception
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-54">
      <div class="info">
        Extracted source (around line <strong>#17</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>15</span>
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      _, headers, body = response = @app.call(env)
</div><div class="line">
</div><div class="line">      if headers[&#39;X-Cascade&#39;] == &#39;pass&#39;
</div><div class="line">        body.close if body.respond_to?(:close)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-55">
      <div class="info">
        Extracted source (around line <strong>#28</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>26</span>
<span>27</span>
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        end
</div><div class="line">
</div><div class="line active">        status, headers, body = @app.call(env)
</div><div class="line">
</div><div class="line">        if exception = env[&#39;web_console.exception&#39;]
</div><div class="line">          session = Session.from_exception(exception)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-56">
      <div class="info">
        Extracted source (around line <strong>#18</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      app_exception = catch :app_exception do
</div><div class="line">        request = create_regular_or_whiny_request(env)
</div><div class="line">        return @app.call(env) unless request.from_whitelited_ip?
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-57">
      <div class="info">
        Extracted source (around line <strong>#18</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      app_exception = catch :app_exception do
</div><div class="line">        request = create_regular_or_whiny_request(env)
</div><div class="line">        return @app.call(env) unless request.from_whitelited_ip?
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-58">
      <div class="info">
        Extracted source (around line <strong>#30</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      @app.call(env)
</div><div class="line">    rescue Exception =&gt; exception
</div><div class="line">      if env[&#39;action_dispatch.show_exceptions&#39;] == false
</div><div class="line">        raise exception
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-59">
      <div class="info">
        Extracted source (around line <strong>#38</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>36</span>
<span>37</span>
<span>38</span>
<span>39</span>
<span>40</span>
<span>41</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        instrumenter.start &#39;request.action_dispatch&#39;, request: request
</div><div class="line">        logger.info { started_request_message(request) }
</div><div class="line active">        resp = @app.call(env)
</div><div class="line">        resp[2] = ::Rack::BodyProxy.new(resp[2]) { finish(request) }
</div><div class="line">        resp
</div><div class="line">      rescue Exception
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-60">
      <div class="info">
        Extracted source (around line <strong>#20</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
<span>22</span>
<span>23</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">        if logger.respond_to?(:tagged)
</div><div class="line active">          logger.tagged(compute_tags(request)) { call_app(request, env) }
</div><div class="line">        else
</div><div class="line">          call_app(request, env)
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-61">
      <div class="info">
        Extracted source (around line <strong>#68</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>66</span>
<span>67</span>
<span>68</span>
<span>69</span>
<span>70</span>
<span>71</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def tagged(*tags)
</div><div class="line active">      formatter.tagged(*tags) { yield self }
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    def flush
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-62">
      <div class="info">
        Extracted source (around line <strong>#26</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>24</span>
<span>25</span>
<span>26</span>
<span>27</span>
<span>28</span>
<span>29</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def tagged(*tags)
</div><div class="line">        new_tags = push_tags(*tags)
</div><div class="line active">        yield self
</div><div class="line">      ensure
</div><div class="line">        pop_tags(new_tags.size)
</div><div class="line">      end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-63">
      <div class="info">
        Extracted source (around line <strong>#68</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>66</span>
<span>67</span>
<span>68</span>
<span>69</span>
<span>70</span>
<span>71</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def tagged(*tags)
</div><div class="line active">      formatter.tagged(*tags) { yield self }
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    def flush
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-64">
      <div class="info">
        Extracted source (around line <strong>#20</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
<span>22</span>
<span>23</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">        if logger.respond_to?(:tagged)
</div><div class="line active">          logger.tagged(compute_tags(request)) { call_app(request, env) }
</div><div class="line">        else
</div><div class="line">          call_app(request, env)
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-65">
      <div class="info">
        Extracted source (around line <strong>#9</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>7</span>
<span>8</span>
<span>9</span>
<span>10</span>
<span>11</span>
<span>12</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def call(env)
</div><div class="line">      RequestStore.begin!
</div><div class="line active">      @app.call(env)
</div><div class="line">    ensure
</div><div class="line">      RequestStore.end!
</div><div class="line">      RequestStore.clear!
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-66">
      <div class="info">
        Extracted source (around line <strong>#21</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>19</span>
<span>20</span>
<span>21</span>
<span>22</span>
<span>23</span>
<span>24</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def call(env)
</div><div class="line">      env[&quot;action_dispatch.request_id&quot;] = external_request_id(env) || internal_request_id
</div><div class="line active">      @app.call(env).tap { |_status, headers, _body| headers[&quot;X-Request-Id&quot;] = env[&quot;action_dispatch.request_id&quot;] }
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    private
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-67">
      <div class="info">
        Extracted source (around line <strong>#22</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>20</span>
<span>21</span>
<span>22</span>
<span>23</span>
<span>24</span>
<span>25</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      end
</div><div class="line">
</div><div class="line active">      @app.call(env)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    def method_override(env)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-68">
      <div class="info">
        Extracted source (around line <strong>#18</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
<span>21</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def call(env)
</div><div class="line">      start_time = clock_time
</div><div class="line active">      status, headers, body = @app.call(env)
</div><div class="line">      request_time = clock_time - start_time
</div><div class="line">
</div><div class="line">      if !headers.has_key?(@header_name)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-69">
      <div class="info">
        Extracted source (around line <strong>#28</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>26</span>
<span>27</span>
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          def call(env)
</div><div class="line">            LocalCacheRegistry.set_cache_for(local_cache_key, LocalStore.new)
</div><div class="line active">            response = @app.call(env)
</div><div class="line">            response[2] = ::Rack::BodyProxy.new(response[2]) do
</div><div class="line">              LocalCacheRegistry.set_cache_for(local_cache_key, nil)
</div><div class="line">            end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-70">
      <div class="info">
        Extracted source (around line <strong>#17</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>15</span>
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
<span>20</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      old, env[FLAG] = env[FLAG], false
</div><div class="line">      @mutex.lock
</div><div class="line active">      response = @app.call(env)
</div><div class="line">      body = BodyProxy.new(response[2]) { @mutex.unlock }
</div><div class="line">      response[2] = body
</div><div class="line">      response
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-71">
      <div class="info">
        Extracted source (around line <strong>#116</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>114</span>
<span>115</span>
<span>116</span>
<span>117</span>
<span>118</span>
<span>119</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      end
</div><div class="line">
</div><div class="line active">      @app.call(env)
</div><div class="line">    end
</div><div class="line">  end
</div><div class="line">end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-72">
      <div class="info">
        Extracted source (around line <strong>#113</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>111</span>
<span>112</span>
<span>113</span>
<span>114</span>
<span>115</span>
<span>116</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      status, headers, body = @app.call(env)
</div><div class="line">      if body.respond_to?(:to_path)
</div><div class="line">        case type = variation(env)
</div><div class="line">        when &#39;X-Accel-Redirect&#39;
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-73">
      <div class="info">
        Extracted source (around line <strong>#16</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>14</span>
<span>15</span>
<span>16</span>
<span>17</span>
<span>18</span>
<span>19</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def _call(env)
</div><div class="line active">      status, headers, body = @app.call(env)
</div><div class="line">
</div><div class="line">      if env[&#39;airbrake.error_id&#39;] &amp;&amp; Airbrake.configuration.user_information
</div><div class="line">        new_body = []
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-74">
      <div class="info">
        Extracted source (around line <strong>#12</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>10</span>
<span>11</span>
<span>12</span>
<span>13</span>
<span>14</span>
<span>15</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">    def call(env)
</div><div class="line active">      dup._call(env)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    def _call(env)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-75">
      <div class="info">
        Extracted source (around line <strong>#518</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>516</span>
<span>517</span>
<span>518</span>
<span>519</span>
<span>520</span>
<span>521</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        env[&quot;ROUTES_#{routes.object_id}_SCRIPT_NAME&quot;] = env[&#39;SCRIPT_NAME&#39;].dup
</div><div class="line">      end
</div><div class="line active">      app.call(env)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    # Defines additional Rack env configuration that is added on each call.
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-76">
      <div class="info">
        Extracted source (around line <strong>#165</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>163</span>
<span>164</span>
<span>165</span>
<span>166</span>
<span>167</span>
<span>168</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      env[&quot;ORIGINAL_FULLPATH&quot;] = build_original_fullpath(env)
</div><div class="line">      env[&quot;ORIGINAL_SCRIPT_NAME&quot;] = env[&quot;SCRIPT_NAME&quot;]
</div><div class="line active">      super(env)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    # Reload application routes regardless if they changed or not.
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-77">
      <div class="info">
        Extracted source (around line <strong>#30</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>28</span>
<span>29</span>
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      env[&quot;HTTP_COOKIE&quot;] ||= cookie_jar.for(uri)
</div><div class="line">      @last_request = Rack::Request.new(env)
</div><div class="line active">      status, headers, body = @app.call(@last_request.env)
</div><div class="line">
</div><div class="line">      @last_response = MockResponse.new(status, headers, body, env[&quot;rack.errors&quot;].flush)
</div><div class="line">      body.close if body.respond_to?(:close)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-78">
      <div class="info">
        Extracted source (around line <strong>#244</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>242</span>
<span>243</span>
<span>244</span>
<span>245</span>
<span>246</span>
<span>247</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        uri.host ||= @default_host
</div><div class="line">
</div><div class="line active">        @rack_mock_session.request(uri, env)
</div><div class="line">
</div><div class="line">        if retry_with_digest_auth?(env)
</div><div class="line">          auth_env = env.merge({
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-79">
      <div class="info">
        Extracted source (around line <strong>#124</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>122</span>
<span>123</span>
<span>124</span>
<span>125</span>
<span>126</span>
<span>127</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      def request(uri, env = {}, &amp;block)
</div><div class="line">        env = env_for(uri, env)
</div><div class="line active">        process_request(uri, env, &amp;block)
</div><div class="line">      end
</div><div class="line">
</div><div class="line">      # Set a header to be included on all subsequent requests through the
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-80">
      <div class="info">
        Extracted source (around line <strong>#297</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>295</span>
<span>296</span>
<span>297</span>
<span>298</span>
<span>299</span>
<span>300</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          # NOTE: rack-test v0.5 doesn&#39;t build a default uri correctly
</div><div class="line">          # Make sure requested path is always a full uri
</div><div class="line active">          session.request(build_full_uri(path, env), env)
</div><div class="line">
</div><div class="line">          @request_count += 1
</div><div class="line">          @request  = ActionDispatch::Request.new(session.last_request.env)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-81">
      <div class="info">
        Extracted source (around line <strong>#32</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>30</span>
<span>31</span>
<span>32</span>
<span>33</span>
<span>34</span>
<span>35</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      # +#post+, +#patch+, +#put+, +#delete+, and +#head+.
</div><div class="line">      def get(path, parameters = nil, headers_or_env = nil)
</div><div class="line active">        process :get, path, parameters, headers_or_env
</div><div class="line">      end
</div><div class="line">
</div><div class="line">      # Performs a POST request with the given parameters. See +#get+ for more
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-82">
      <div class="info">
        Extracted source (around line <strong>#99</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>97</span>
<span>98</span>
<span>99</span>
<span>100</span>
<span>101</span>
<span>102</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">             example = r[:responseModel]
</div><div class="line">             app = ActionDispatch::Integration::Session.new(Rails.application)
</div><div class="line active">             response = app.send(op[:method], &#39;/&#39; + api[:path], example[:query], example[:headers])
</div><div class="line">             json = app.body.chomp
</div><div class="line">             object = nil
</div><div class="line">             begin
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-83">
      <div class="info">
        Extracted source (around line <strong>#89</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>87</span>
<span>88</span>
<span>89</span>
<span>90</span>
<span>91</span>
<span>92</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">           }
</div><div class="line">
</div><div class="line active">           op[:response_messages].each do |r|
</div><div class="line">
</div><div class="line">             status = r[:code]
</div><div class="line">             status == :ok if status == :success
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-84">
      <div class="info">
        Extracted source (around line <strong>#89</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>87</span>
<span>88</span>
<span>89</span>
<span>90</span>
<span>91</span>
<span>92</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">           }
</div><div class="line">
</div><div class="line active">           op[:response_messages].each do |r|
</div><div class="line">
</div><div class="line">             status = r[:code]
</div><div class="line">             status == :ok if status == :success
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-85">
      <div class="info">
        Extracted source (around line <strong>#74</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>72</span>
<span>73</span>
<span>74</span>
<span>75</span>
<span>76</span>
<span>77</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">         path = api[:path].gsub(/^api\//, &#39;&#39;).gsub(&#39;/&#39;, &#39;_&#39;)
</div><div class="line">
</div><div class="line active">         api[:operations].each do |op|
</div><div class="line">
</div><div class="line">           next if op[:response_messages].first[:responseModel].nil?
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-86">
      <div class="info">
        Extracted source (around line <strong>#74</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>72</span>
<span>73</span>
<span>74</span>
<span>75</span>
<span>76</span>
<span>77</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">         path = api[:path].gsub(/^api\//, &#39;&#39;).gsub(&#39;/&#39;, &#39;_&#39;)
</div><div class="line">
</div><div class="line active">         api[:operations].each do |op|
</div><div class="line">
</div><div class="line">           next if op[:response_messages].first[:responseModel].nil?
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-87">
      <div class="info">
        Extracted source (around line <strong>#68</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>66</span>
<span>67</span>
<span>68</span>
<span>69</span>
<span>70</span>
<span>71</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">      docs.each do |doc|
</div><div class="line active">       doc[:apis].each do |api|
</div><div class="line">
</div><div class="line">         api[:path].gsub!(/^\//, &#39;&#39;)
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-88">
      <div class="info">
        Extracted source (around line <strong>#68</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>66</span>
<span>67</span>
<span>68</span>
<span>69</span>
<span>70</span>
<span>71</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">      docs.each do |doc|
</div><div class="line active">       doc[:apis].each do |api|
</div><div class="line">
</div><div class="line">         api[:path].gsub!(/^\//, &#39;&#39;)
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-89">
      <div class="info">
        Extracted source (around line <strong>#67</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>65</span>
<span>66</span>
<span>67</span>
<span>68</span>
<span>69</span>
<span>70</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      docs = Swagger::Docs::Generator.generate_docs(Swagger::Docs::Config.registered_apis)[version][:processed]
</div><div class="line">
</div><div class="line active">      docs.each do |doc|
</div><div class="line">       doc[:apis].each do |api|
</div><div class="line">
</div><div class="line">         api[:path].gsub!(/^\//, &#39;&#39;)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-90">
      <div class="info">
        Extracted source (around line <strong>#67</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>65</span>
<span>66</span>
<span>67</span>
<span>68</span>
<span>69</span>
<span>70</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      docs = Swagger::Docs::Generator.generate_docs(Swagger::Docs::Config.registered_apis)[version][:processed]
</div><div class="line">
</div><div class="line active">      docs.each do |doc|
</div><div class="line">       doc[:apis].each do |api|
</div><div class="line">
</div><div class="line">         api[:path].gsub!(/^\//, &#39;&#39;)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-91">
      <div class="info">
        Extracted source (around line <strong>#248</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>246</span>
<span>247</span>
<span>248</span>
<span>249</span>
<span>250</span>
<span>251</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          act.call(self)
</div><div class="line">        else
</div><div class="line active">          act.call(self, args)
</div><div class="line">        end
</div><div class="line">      end
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-92">
      <div class="info">
        Extracted source (around line <strong>#248</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>246</span>
<span>247</span>
<span>248</span>
<span>249</span>
<span>250</span>
<span>251</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          act.call(self)
</div><div class="line">        else
</div><div class="line active">          act.call(self, args)
</div><div class="line">        end
</div><div class="line">      end
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-93">
      <div class="info">
        Extracted source (around line <strong>#243</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>241</span>
<span>242</span>
<span>243</span>
<span>244</span>
<span>245</span>
<span>246</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      application.trace &quot;** Execute #{name}&quot; if application.options.trace
</div><div class="line">      application.enhance_with_matching_rule(name) if @actions.empty?
</div><div class="line active">      @actions.each do |act|
</div><div class="line">        case act.arity
</div><div class="line">        when 1
</div><div class="line">          act.call(self)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-94">
      <div class="info">
        Extracted source (around line <strong>#243</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>241</span>
<span>242</span>
<span>243</span>
<span>244</span>
<span>245</span>
<span>246</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      application.trace &quot;** Execute #{name}&quot; if application.options.trace
</div><div class="line">      application.enhance_with_matching_rule(name) if @actions.empty?
</div><div class="line active">      @actions.each do |act|
</div><div class="line">        case act.arity
</div><div class="line">        when 1
</div><div class="line">          act.call(self)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-95">
      <div class="info">
        Extracted source (around line <strong>#187</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>185</span>
<span>186</span>
<span>187</span>
<span>188</span>
<span>189</span>
<span>190</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        @already_invoked = true
</div><div class="line">        invoke_prerequisites(task_args, new_chain)
</div><div class="line active">        execute(task_args) if needed?
</div><div class="line">      end
</div><div class="line">    rescue Exception =&gt; ex
</div><div class="line">      add_chain_to(ex, new_chain)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-96">
      <div class="info">
        Extracted source (around line <strong>#211</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>209</span>
<span>210</span>
<span>211</span>
<span>212</span>
<span>213</span>
<span>214</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    mon_enter
</div><div class="line">    begin
</div><div class="line active">      yield
</div><div class="line">    ensure
</div><div class="line">      mon_exit
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-97">
      <div class="info">
        Extracted source (around line <strong>#180</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>178</span>
<span>179</span>
<span>180</span>
<span>181</span>
<span>182</span>
<span>183</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def invoke_with_call_chain(task_args, invocation_chain) # :nodoc:
</div><div class="line">      new_chain = InvocationChain.append(self, invocation_chain)
</div><div class="line active">      @lock.synchronize do
</div><div class="line">        if application.options.trace
</div><div class="line">          application.trace &quot;** Invoke #{name} #{format_trace_flags}&quot;
</div><div class="line">        end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-98">
      <div class="info">
        Extracted source (around line <strong>#173</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>171</span>
<span>172</span>
<span>173</span>
<span>174</span>
<span>175</span>
<span>176</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    def invoke(*args)
</div><div class="line">      task_args = TaskArguments.new(arg_names, args)
</div><div class="line active">      invoke_with_call_chain(task_args, InvocationChain::EMPTY)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    # Same as invoke, but explicitly pass a call chain to detect
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-99">
      <div class="info">
        Extracted source (around line <strong>#150</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>148</span>
<span>149</span>
<span>150</span>
<span>151</span>
<span>152</span>
<span>153</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      name, args = parse_task_string(task_string)
</div><div class="line">      t = self[name]
</div><div class="line active">      t.invoke(*args)
</div><div class="line">    end
</div><div class="line">
</div><div class="line">    def parse_task_string(string) # :nodoc:
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-100">
      <div class="info">
        Extracted source (around line <strong>#106</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>104</span>
<span>105</span>
<span>106</span>
<span>107</span>
<span>108</span>
<span>109</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          display_prerequisites
</div><div class="line">        else
</div><div class="line active">          top_level_tasks.each { |task_name| invoke_task(task_name) }
</div><div class="line">        end
</div><div class="line">      end
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-101">
      <div class="info">
        Extracted source (around line <strong>#106</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>104</span>
<span>105</span>
<span>106</span>
<span>107</span>
<span>108</span>
<span>109</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          display_prerequisites
</div><div class="line">        else
</div><div class="line active">          top_level_tasks.each { |task_name| invoke_task(task_name) }
</div><div class="line">        end
</div><div class="line">      end
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-102">
      <div class="info">
        Extracted source (around line <strong>#106</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>104</span>
<span>105</span>
<span>106</span>
<span>107</span>
<span>108</span>
<span>109</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">          display_prerequisites
</div><div class="line">        else
</div><div class="line active">          top_level_tasks.each { |task_name| invoke_task(task_name) }
</div><div class="line">        end
</div><div class="line">      end
</div><div class="line">    end
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-103">
      <div class="info">
        Extracted source (around line <strong>#115</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>113</span>
<span>114</span>
<span>115</span>
<span>116</span>
<span>117</span>
<span>118</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">      thread_pool.gather_history if options.job_stats == :history
</div><div class="line">
</div><div class="line active">      yield
</div><div class="line">
</div><div class="line">      thread_pool.join
</div><div class="line">      if options.job_stats
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-104">
      <div class="info">
        Extracted source (around line <strong>#100</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>98</span>
<span>99</span>
<span>100</span>
<span>101</span>
<span>102</span>
<span>103</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    # Run the top level tasks of a Rake application.
</div><div class="line">    def top_level
</div><div class="line active">      run_with_threads do
</div><div class="line">        if options.show_tasks
</div><div class="line">          display_tasks_and_comments
</div><div class="line">        elsif options.show_prereqs
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-105">
      <div class="info">
        Extracted source (around line <strong>#78</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>76</span>
<span>77</span>
<span>78</span>
<span>79</span>
<span>80</span>
<span>81</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">        init
</div><div class="line">        load_rakefile
</div><div class="line active">        top_level
</div><div class="line">      end
</div><div class="line">    end
</div><div class="line">
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-106">
      <div class="info">
        Extracted source (around line <strong>#176</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>174</span>
<span>175</span>
<span>176</span>
<span>177</span>
<span>178</span>
<span>179</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    # Provide standard exception handling for the given block.
</div><div class="line">    def standard_exception_handling # :nodoc:
</div><div class="line active">      yield
</div><div class="line">    rescue SystemExit
</div><div class="line">      # Exit silently with current status
</div><div class="line">      raise
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-107">
      <div class="info">
        Extracted source (around line <strong>#75</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>73</span>
<span>74</span>
<span>75</span>
<span>76</span>
<span>77</span>
<span>78</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">    # call +top_level+ to run your top level tasks.
</div><div class="line">    def run
</div><div class="line active">      standard_exception_handling do
</div><div class="line">        init
</div><div class="line">        load_rakefile
</div><div class="line">        top_level
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-108">
      <div class="info">
        Extracted source (around line <strong>#33</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>31</span>
<span>32</span>
<span>33</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">require &#39;rake&#39;
</div><div class="line">
</div><div class="line active">Rake.application.run
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-109">
      <div class="info">
        Extracted source (around line <strong>#23</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>21</span>
<span>22</span>
<span>23</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">gem &#39;rake&#39;, version
</div><div class="line active">load Gem.bin_path(&#39;rake&#39;, &#39;rake&#39;, version)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>
    <div class="source hidden" id="frame-source-110">
      <div class="info">
        Extracted source (around line <strong>#23</strong>):
      </div>
      <div class="data">
        <table cellpadding="0" cellspacing="0" class="lines">
          <tr>
            <td>
              <pre class="line_numbers">
<span>21</span>
<span>22</span>
<span>23</span>
              </pre>
            </td>
<td width="100%">
<pre>
<div class="line">
</div><div class="line">gem &#39;rake&#39;, version
</div><div class="line active">load Gem.bin_path(&#39;rake&#39;, &#39;rake&#39;, version)
</div>
</pre>
</td>
          </tr>
        </table>
      </div>
    </div>

  
<p><code>Rails.root: /media/hdd/src/meedan/lapis-example</code></p>

<div id="traces">
    <a href="#" onclick="hide(&#39;Framework-Trace&#39;);hide(&#39;Full-Trace&#39;);show(&#39;Application-Trace&#39;);; return false;">Application Trace</a> |
    <a href="#" onclick="hide(&#39;Application-Trace&#39;);hide(&#39;Full-Trace&#39;);show(&#39;Framework-Trace&#39;);; return false;">Framework Trace</a> |
    <a href="#" onclick="hide(&#39;Application-Trace&#39;);hide(&#39;Framework-Trace&#39;);show(&#39;Full-Trace&#39;);; return false;">Full Trace</a> 

    <div id="Application-Trace" style="display: block;">
      <pre><code><a class="trace-frames" data-frame-id="0" href="#">app/controllers/api/v1/languages_controller.rb:8:in `classify&#39;</a><br><a class="trace-frames" data-frame-id="82" href="#">lib/tasks/client_gem.rake:99:in `block (7 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="83" href="#">lib/tasks/client_gem.rake:89:in `each&#39;</a><br><a class="trace-frames" data-frame-id="84" href="#">lib/tasks/client_gem.rake:89:in `block (6 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="85" href="#">lib/tasks/client_gem.rake:74:in `each&#39;</a><br><a class="trace-frames" data-frame-id="86" href="#">lib/tasks/client_gem.rake:74:in `block (5 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="87" href="#">lib/tasks/client_gem.rake:68:in `each&#39;</a><br><a class="trace-frames" data-frame-id="88" href="#">lib/tasks/client_gem.rake:68:in `block (4 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="89" href="#">lib/tasks/client_gem.rake:67:in `each&#39;</a><br><a class="trace-frames" data-frame-id="90" href="#">lib/tasks/client_gem.rake:67:in `block (3 levels) in &lt;top (required)&gt;&#39;</a><br></code></pre>
    </div>
    <div id="Framework-Trace" style="display: none;">
      <pre><code><a class="trace-frames" data-frame-id="1" href="#">actionpack (4.2.4) lib/action_controller/metal/implicit_render.rb:4:in `send_action&#39;</a><br><a class="trace-frames" data-frame-id="2" href="#">actionpack (4.2.4) lib/abstract_controller/base.rb:198:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="3" href="#">actionpack (4.2.4) lib/action_controller/metal/rendering.rb:10:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="4" href="#">actionpack (4.2.4) lib/abstract_controller/callbacks.rb:20:in `block in process_action&#39;</a><br><a class="trace-frames" data-frame-id="5" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:117:in `call&#39;</a><br><a class="trace-frames" data-frame-id="6" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:117:in `call&#39;</a><br><a class="trace-frames" data-frame-id="7" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:555:in `block (2 levels) in compile&#39;</a><br><a class="trace-frames" data-frame-id="8" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:505:in `call&#39;</a><br><a class="trace-frames" data-frame-id="9" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:505:in `call&#39;</a><br><a class="trace-frames" data-frame-id="10" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:92:in `__run_callbacks__&#39;</a><br><a class="trace-frames" data-frame-id="11" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:778:in `_run_process_action_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="12" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:81:in `run_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="13" href="#">actionpack (4.2.4) lib/abstract_controller/callbacks.rb:19:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="14" href="#">actionpack (4.2.4) lib/action_controller/metal/rescue.rb:29:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="15" href="#">actionpack (4.2.4) lib/action_controller/metal/instrumentation.rb:32:in `block in process_action&#39;</a><br><a class="trace-frames" data-frame-id="16" href="#">activesupport (4.2.4) lib/active_support/notifications.rb:164:in `block in instrument&#39;</a><br><a class="trace-frames" data-frame-id="17" href="#">activesupport (4.2.4) lib/active_support/notifications/instrumenter.rb:20:in `instrument&#39;</a><br><a class="trace-frames" data-frame-id="18" href="#">activesupport (4.2.4) lib/active_support/notifications.rb:164:in `instrument&#39;</a><br><a class="trace-frames" data-frame-id="19" href="#">actionpack (4.2.4) lib/action_controller/metal/instrumentation.rb:30:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="20" href="#">actionpack (4.2.4) lib/action_controller/metal/params_wrapper.rb:250:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="21" href="#">activerecord (4.2.4) lib/active_record/railties/controller_runtime.rb:18:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="22" href="#">actionpack (4.2.4) lib/abstract_controller/base.rb:137:in `process&#39;</a><br><a class="trace-frames" data-frame-id="23" href="#">actionview (4.2.4) lib/action_view/rendering.rb:30:in `process&#39;</a><br><a class="trace-frames" data-frame-id="24" href="#">actionpack (4.2.4) lib/action_controller/metal.rb:196:in `dispatch&#39;</a><br><a class="trace-frames" data-frame-id="25" href="#">actionpack (4.2.4) lib/action_controller/metal/rack_delegation.rb:13:in `dispatch&#39;</a><br><a class="trace-frames" data-frame-id="26" href="#">actionpack (4.2.4) lib/action_controller/metal.rb:237:in `block in action&#39;</a><br><a class="trace-frames" data-frame-id="27" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:76:in `call&#39;</a><br><a class="trace-frames" data-frame-id="28" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:76:in `dispatch&#39;</a><br><a class="trace-frames" data-frame-id="29" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:45:in `serve&#39;</a><br><a class="trace-frames" data-frame-id="30" href="#">actionpack (4.2.4) lib/action_dispatch/routing/mapper.rb:49:in `serve&#39;</a><br><a class="trace-frames" data-frame-id="31" href="#">actionpack (4.2.4) lib/action_dispatch/journey/router.rb:43:in `block in serve&#39;</a><br><a class="trace-frames" data-frame-id="32" href="#">actionpack (4.2.4) lib/action_dispatch/journey/router.rb:30:in `each&#39;</a><br><a class="trace-frames" data-frame-id="33" href="#">actionpack (4.2.4) lib/action_dispatch/journey/router.rb:30:in `serve&#39;</a><br><a class="trace-frames" data-frame-id="34" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:821:in `call&#39;</a><br><a class="trace-frames" data-frame-id="35" href="#">rack (1.6.4) lib/rack/etag.rb:24:in `call&#39;</a><br><a class="trace-frames" data-frame-id="36" href="#">rack (1.6.4) lib/rack/conditionalget.rb:25:in `call&#39;</a><br><a class="trace-frames" data-frame-id="37" href="#">rack (1.6.4) lib/rack/head.rb:13:in `call&#39;</a><br><a class="trace-frames" data-frame-id="38" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/params_parser.rb:27:in `call&#39;</a><br><a class="trace-frames" data-frame-id="39" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/flash.rb:260:in `call&#39;</a><br><a class="trace-frames" data-frame-id="40" href="#">rack (1.6.4) lib/rack/session/abstract/id.rb:225:in `context&#39;</a><br><a class="trace-frames" data-frame-id="41" href="#">rack (1.6.4) lib/rack/session/abstract/id.rb:220:in `call&#39;</a><br><a class="trace-frames" data-frame-id="42" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/cookies.rb:560:in `call&#39;</a><br><a class="trace-frames" data-frame-id="43" href="#">activerecord (4.2.4) lib/active_record/query_cache.rb:36:in `call&#39;</a><br><a class="trace-frames" data-frame-id="44" href="#">activerecord (4.2.4) lib/active_record/connection_adapters/abstract/connection_pool.rb:653:in `call&#39;</a><br><a class="trace-frames" data-frame-id="45" href="#">activerecord (4.2.4) lib/active_record/migration.rb:377:in `call&#39;</a><br><a class="trace-frames" data-frame-id="46" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/callbacks.rb:29:in `block in call&#39;</a><br><a class="trace-frames" data-frame-id="47" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:88:in `__run_callbacks__&#39;</a><br><a class="trace-frames" data-frame-id="48" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:778:in `_run_call_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="49" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:81:in `run_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="50" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/callbacks.rb:27:in `call&#39;</a><br><a class="trace-frames" data-frame-id="51" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/reloader.rb:73:in `call&#39;</a><br><a class="trace-frames" data-frame-id="52" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/remote_ip.rb:78:in `call&#39;</a><br><a class="trace-frames" data-frame-id="53" href="#">airbrake (4.3.3) lib/airbrake/rails/middleware.rb:13:in `call&#39;</a><br><a class="trace-frames" data-frame-id="54" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/debug_exceptions.rb:17:in `call&#39;</a><br><a class="trace-frames" data-frame-id="55" href="#">web-console (2.3.0) lib/web_console/middleware.rb:28:in `block in call&#39;</a><br><a class="trace-frames" data-frame-id="56" href="#">web-console (2.3.0) lib/web_console/middleware.rb:18:in `catch&#39;</a><br><a class="trace-frames" data-frame-id="57" href="#">web-console (2.3.0) lib/web_console/middleware.rb:18:in `call&#39;</a><br><a class="trace-frames" data-frame-id="58" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/show_exceptions.rb:30:in `call&#39;</a><br><a class="trace-frames" data-frame-id="59" href="#">railties (4.2.4) lib/rails/rack/logger.rb:38:in `call_app&#39;</a><br><a class="trace-frames" data-frame-id="60" href="#">railties (4.2.4) lib/rails/rack/logger.rb:20:in `block in call&#39;</a><br><a class="trace-frames" data-frame-id="61" href="#">activesupport (4.2.4) lib/active_support/tagged_logging.rb:68:in `block in tagged&#39;</a><br><a class="trace-frames" data-frame-id="62" href="#">activesupport (4.2.4) lib/active_support/tagged_logging.rb:26:in `tagged&#39;</a><br><a class="trace-frames" data-frame-id="63" href="#">activesupport (4.2.4) lib/active_support/tagged_logging.rb:68:in `tagged&#39;</a><br><a class="trace-frames" data-frame-id="64" href="#">railties (4.2.4) lib/rails/rack/logger.rb:20:in `call&#39;</a><br><a class="trace-frames" data-frame-id="65" href="#">request_store (1.3.0) lib/request_store/middleware.rb:9:in `call&#39;</a><br><a class="trace-frames" data-frame-id="66" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/request_id.rb:21:in `call&#39;</a><br><a class="trace-frames" data-frame-id="67" href="#">rack (1.6.4) lib/rack/methodoverride.rb:22:in `call&#39;</a><br><a class="trace-frames" data-frame-id="68" href="#">rack (1.6.4) lib/rack/runtime.rb:18:in `call&#39;</a><br><a class="trace-frames" data-frame-id="69" href="#">activesupport (4.2.4) lib/active_support/cache/strategy/local_cache_middleware.rb:28:in `call&#39;</a><br><a class="trace-frames" data-frame-id="70" href="#">rack (1.6.4) lib/rack/lock.rb:17:in `call&#39;</a><br><a class="trace-frames" data-frame-id="71" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/static.rb:116:in `call&#39;</a><br><a class="trace-frames" data-frame-id="72" href="#">rack (1.6.4) lib/rack/sendfile.rb:113:in `call&#39;</a><br><a class="trace-frames" data-frame-id="73" href="#">airbrake (4.3.3) lib/airbrake/user_informer.rb:16:in `_call&#39;</a><br><a class="trace-frames" data-frame-id="74" href="#">airbrake (4.3.3) lib/airbrake/user_informer.rb:12:in `call&#39;</a><br><a class="trace-frames" data-frame-id="75" href="#">railties (4.2.4) lib/rails/engine.rb:518:in `call&#39;</a><br><a class="trace-frames" data-frame-id="76" href="#">railties (4.2.4) lib/rails/application.rb:165:in `call&#39;</a><br><a class="trace-frames" data-frame-id="77" href="#">rack-test (0.6.3) lib/rack/mock_session.rb:30:in `request&#39;</a><br><a class="trace-frames" data-frame-id="78" href="#">rack-test (0.6.3) lib/rack/test.rb:244:in `process_request&#39;</a><br><a class="trace-frames" data-frame-id="79" href="#">rack-test (0.6.3) lib/rack/test.rb:124:in `request&#39;</a><br><a class="trace-frames" data-frame-id="80" href="#">actionpack (4.2.4) lib/action_dispatch/testing/integration.rb:297:in `process&#39;</a><br><a class="trace-frames" data-frame-id="81" href="#">actionpack (4.2.4) lib/action_dispatch/testing/integration.rb:32:in `get&#39;</a><br><a class="trace-frames" data-frame-id="91" href="#">rake (11.1.1) lib/rake/task.rb:248:in `call&#39;</a><br><a class="trace-frames" data-frame-id="92" href="#">rake (11.1.1) lib/rake/task.rb:248:in `block in execute&#39;</a><br><a class="trace-frames" data-frame-id="93" href="#">rake (11.1.1) lib/rake/task.rb:243:in `each&#39;</a><br><a class="trace-frames" data-frame-id="94" href="#">rake (11.1.1) lib/rake/task.rb:243:in `execute&#39;</a><br><a class="trace-frames" data-frame-id="95" href="#">rake (11.1.1) lib/rake/task.rb:187:in `block in invoke_with_call_chain&#39;</a><br><a class="trace-frames" data-frame-id="96" href="#">/home/kratib/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/monitor.rb:211:in `mon_synchronize&#39;</a><br><a class="trace-frames" data-frame-id="97" href="#">rake (11.1.1) lib/rake/task.rb:180:in `invoke_with_call_chain&#39;</a><br><a class="trace-frames" data-frame-id="98" href="#">rake (11.1.1) lib/rake/task.rb:173:in `invoke&#39;</a><br><a class="trace-frames" data-frame-id="99" href="#">rake (11.1.1) lib/rake/application.rb:150:in `invoke_task&#39;</a><br><a class="trace-frames" data-frame-id="100" href="#">rake (11.1.1) lib/rake/application.rb:106:in `block (2 levels) in top_level&#39;</a><br><a class="trace-frames" data-frame-id="101" href="#">rake (11.1.1) lib/rake/application.rb:106:in `each&#39;</a><br><a class="trace-frames" data-frame-id="102" href="#">rake (11.1.1) lib/rake/application.rb:106:in `block in top_level&#39;</a><br><a class="trace-frames" data-frame-id="103" href="#">rake (11.1.1) lib/rake/application.rb:115:in `run_with_threads&#39;</a><br><a class="trace-frames" data-frame-id="104" href="#">rake (11.1.1) lib/rake/application.rb:100:in `top_level&#39;</a><br><a class="trace-frames" data-frame-id="105" href="#">rake (11.1.1) lib/rake/application.rb:78:in `block in run&#39;</a><br><a class="trace-frames" data-frame-id="106" href="#">rake (11.1.1) lib/rake/application.rb:176:in `standard_exception_handling&#39;</a><br><a class="trace-frames" data-frame-id="107" href="#">rake (11.1.1) lib/rake/application.rb:75:in `run&#39;</a><br><a class="trace-frames" data-frame-id="108" href="#">rake (11.1.1) bin/rake:33:in `&lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="109" href="#">/home/kratib/.rvm/gems/ruby-2.2.1/bin/rake:23:in `load&#39;</a><br><a class="trace-frames" data-frame-id="110" href="#">/home/kratib/.rvm/gems/ruby-2.2.1/bin/rake:23:in `&lt;main&gt;&#39;</a><br></code></pre>
    </div>
    <div id="Full-Trace" style="display: none;">
      <pre><code><a class="trace-frames" data-frame-id="0" href="#">app/controllers/api/v1/languages_controller.rb:8:in `classify&#39;</a><br><a class="trace-frames" data-frame-id="1" href="#">actionpack (4.2.4) lib/action_controller/metal/implicit_render.rb:4:in `send_action&#39;</a><br><a class="trace-frames" data-frame-id="2" href="#">actionpack (4.2.4) lib/abstract_controller/base.rb:198:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="3" href="#">actionpack (4.2.4) lib/action_controller/metal/rendering.rb:10:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="4" href="#">actionpack (4.2.4) lib/abstract_controller/callbacks.rb:20:in `block in process_action&#39;</a><br><a class="trace-frames" data-frame-id="5" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:117:in `call&#39;</a><br><a class="trace-frames" data-frame-id="6" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:117:in `call&#39;</a><br><a class="trace-frames" data-frame-id="7" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:555:in `block (2 levels) in compile&#39;</a><br><a class="trace-frames" data-frame-id="8" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:505:in `call&#39;</a><br><a class="trace-frames" data-frame-id="9" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:505:in `call&#39;</a><br><a class="trace-frames" data-frame-id="10" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:92:in `__run_callbacks__&#39;</a><br><a class="trace-frames" data-frame-id="11" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:778:in `_run_process_action_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="12" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:81:in `run_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="13" href="#">actionpack (4.2.4) lib/abstract_controller/callbacks.rb:19:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="14" href="#">actionpack (4.2.4) lib/action_controller/metal/rescue.rb:29:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="15" href="#">actionpack (4.2.4) lib/action_controller/metal/instrumentation.rb:32:in `block in process_action&#39;</a><br><a class="trace-frames" data-frame-id="16" href="#">activesupport (4.2.4) lib/active_support/notifications.rb:164:in `block in instrument&#39;</a><br><a class="trace-frames" data-frame-id="17" href="#">activesupport (4.2.4) lib/active_support/notifications/instrumenter.rb:20:in `instrument&#39;</a><br><a class="trace-frames" data-frame-id="18" href="#">activesupport (4.2.4) lib/active_support/notifications.rb:164:in `instrument&#39;</a><br><a class="trace-frames" data-frame-id="19" href="#">actionpack (4.2.4) lib/action_controller/metal/instrumentation.rb:30:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="20" href="#">actionpack (4.2.4) lib/action_controller/metal/params_wrapper.rb:250:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="21" href="#">activerecord (4.2.4) lib/active_record/railties/controller_runtime.rb:18:in `process_action&#39;</a><br><a class="trace-frames" data-frame-id="22" href="#">actionpack (4.2.4) lib/abstract_controller/base.rb:137:in `process&#39;</a><br><a class="trace-frames" data-frame-id="23" href="#">actionview (4.2.4) lib/action_view/rendering.rb:30:in `process&#39;</a><br><a class="trace-frames" data-frame-id="24" href="#">actionpack (4.2.4) lib/action_controller/metal.rb:196:in `dispatch&#39;</a><br><a class="trace-frames" data-frame-id="25" href="#">actionpack (4.2.4) lib/action_controller/metal/rack_delegation.rb:13:in `dispatch&#39;</a><br><a class="trace-frames" data-frame-id="26" href="#">actionpack (4.2.4) lib/action_controller/metal.rb:237:in `block in action&#39;</a><br><a class="trace-frames" data-frame-id="27" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:76:in `call&#39;</a><br><a class="trace-frames" data-frame-id="28" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:76:in `dispatch&#39;</a><br><a class="trace-frames" data-frame-id="29" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:45:in `serve&#39;</a><br><a class="trace-frames" data-frame-id="30" href="#">actionpack (4.2.4) lib/action_dispatch/routing/mapper.rb:49:in `serve&#39;</a><br><a class="trace-frames" data-frame-id="31" href="#">actionpack (4.2.4) lib/action_dispatch/journey/router.rb:43:in `block in serve&#39;</a><br><a class="trace-frames" data-frame-id="32" href="#">actionpack (4.2.4) lib/action_dispatch/journey/router.rb:30:in `each&#39;</a><br><a class="trace-frames" data-frame-id="33" href="#">actionpack (4.2.4) lib/action_dispatch/journey/router.rb:30:in `serve&#39;</a><br><a class="trace-frames" data-frame-id="34" href="#">actionpack (4.2.4) lib/action_dispatch/routing/route_set.rb:821:in `call&#39;</a><br><a class="trace-frames" data-frame-id="35" href="#">rack (1.6.4) lib/rack/etag.rb:24:in `call&#39;</a><br><a class="trace-frames" data-frame-id="36" href="#">rack (1.6.4) lib/rack/conditionalget.rb:25:in `call&#39;</a><br><a class="trace-frames" data-frame-id="37" href="#">rack (1.6.4) lib/rack/head.rb:13:in `call&#39;</a><br><a class="trace-frames" data-frame-id="38" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/params_parser.rb:27:in `call&#39;</a><br><a class="trace-frames" data-frame-id="39" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/flash.rb:260:in `call&#39;</a><br><a class="trace-frames" data-frame-id="40" href="#">rack (1.6.4) lib/rack/session/abstract/id.rb:225:in `context&#39;</a><br><a class="trace-frames" data-frame-id="41" href="#">rack (1.6.4) lib/rack/session/abstract/id.rb:220:in `call&#39;</a><br><a class="trace-frames" data-frame-id="42" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/cookies.rb:560:in `call&#39;</a><br><a class="trace-frames" data-frame-id="43" href="#">activerecord (4.2.4) lib/active_record/query_cache.rb:36:in `call&#39;</a><br><a class="trace-frames" data-frame-id="44" href="#">activerecord (4.2.4) lib/active_record/connection_adapters/abstract/connection_pool.rb:653:in `call&#39;</a><br><a class="trace-frames" data-frame-id="45" href="#">activerecord (4.2.4) lib/active_record/migration.rb:377:in `call&#39;</a><br><a class="trace-frames" data-frame-id="46" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/callbacks.rb:29:in `block in call&#39;</a><br><a class="trace-frames" data-frame-id="47" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:88:in `__run_callbacks__&#39;</a><br><a class="trace-frames" data-frame-id="48" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:778:in `_run_call_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="49" href="#">activesupport (4.2.4) lib/active_support/callbacks.rb:81:in `run_callbacks&#39;</a><br><a class="trace-frames" data-frame-id="50" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/callbacks.rb:27:in `call&#39;</a><br><a class="trace-frames" data-frame-id="51" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/reloader.rb:73:in `call&#39;</a><br><a class="trace-frames" data-frame-id="52" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/remote_ip.rb:78:in `call&#39;</a><br><a class="trace-frames" data-frame-id="53" href="#">airbrake (4.3.3) lib/airbrake/rails/middleware.rb:13:in `call&#39;</a><br><a class="trace-frames" data-frame-id="54" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/debug_exceptions.rb:17:in `call&#39;</a><br><a class="trace-frames" data-frame-id="55" href="#">web-console (2.3.0) lib/web_console/middleware.rb:28:in `block in call&#39;</a><br><a class="trace-frames" data-frame-id="56" href="#">web-console (2.3.0) lib/web_console/middleware.rb:18:in `catch&#39;</a><br><a class="trace-frames" data-frame-id="57" href="#">web-console (2.3.0) lib/web_console/middleware.rb:18:in `call&#39;</a><br><a class="trace-frames" data-frame-id="58" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/show_exceptions.rb:30:in `call&#39;</a><br><a class="trace-frames" data-frame-id="59" href="#">railties (4.2.4) lib/rails/rack/logger.rb:38:in `call_app&#39;</a><br><a class="trace-frames" data-frame-id="60" href="#">railties (4.2.4) lib/rails/rack/logger.rb:20:in `block in call&#39;</a><br><a class="trace-frames" data-frame-id="61" href="#">activesupport (4.2.4) lib/active_support/tagged_logging.rb:68:in `block in tagged&#39;</a><br><a class="trace-frames" data-frame-id="62" href="#">activesupport (4.2.4) lib/active_support/tagged_logging.rb:26:in `tagged&#39;</a><br><a class="trace-frames" data-frame-id="63" href="#">activesupport (4.2.4) lib/active_support/tagged_logging.rb:68:in `tagged&#39;</a><br><a class="trace-frames" data-frame-id="64" href="#">railties (4.2.4) lib/rails/rack/logger.rb:20:in `call&#39;</a><br><a class="trace-frames" data-frame-id="65" href="#">request_store (1.3.0) lib/request_store/middleware.rb:9:in `call&#39;</a><br><a class="trace-frames" data-frame-id="66" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/request_id.rb:21:in `call&#39;</a><br><a class="trace-frames" data-frame-id="67" href="#">rack (1.6.4) lib/rack/methodoverride.rb:22:in `call&#39;</a><br><a class="trace-frames" data-frame-id="68" href="#">rack (1.6.4) lib/rack/runtime.rb:18:in `call&#39;</a><br><a class="trace-frames" data-frame-id="69" href="#">activesupport (4.2.4) lib/active_support/cache/strategy/local_cache_middleware.rb:28:in `call&#39;</a><br><a class="trace-frames" data-frame-id="70" href="#">rack (1.6.4) lib/rack/lock.rb:17:in `call&#39;</a><br><a class="trace-frames" data-frame-id="71" href="#">actionpack (4.2.4) lib/action_dispatch/middleware/static.rb:116:in `call&#39;</a><br><a class="trace-frames" data-frame-id="72" href="#">rack (1.6.4) lib/rack/sendfile.rb:113:in `call&#39;</a><br><a class="trace-frames" data-frame-id="73" href="#">airbrake (4.3.3) lib/airbrake/user_informer.rb:16:in `_call&#39;</a><br><a class="trace-frames" data-frame-id="74" href="#">airbrake (4.3.3) lib/airbrake/user_informer.rb:12:in `call&#39;</a><br><a class="trace-frames" data-frame-id="75" href="#">railties (4.2.4) lib/rails/engine.rb:518:in `call&#39;</a><br><a class="trace-frames" data-frame-id="76" href="#">railties (4.2.4) lib/rails/application.rb:165:in `call&#39;</a><br><a class="trace-frames" data-frame-id="77" href="#">rack-test (0.6.3) lib/rack/mock_session.rb:30:in `request&#39;</a><br><a class="trace-frames" data-frame-id="78" href="#">rack-test (0.6.3) lib/rack/test.rb:244:in `process_request&#39;</a><br><a class="trace-frames" data-frame-id="79" href="#">rack-test (0.6.3) lib/rack/test.rb:124:in `request&#39;</a><br><a class="trace-frames" data-frame-id="80" href="#">actionpack (4.2.4) lib/action_dispatch/testing/integration.rb:297:in `process&#39;</a><br><a class="trace-frames" data-frame-id="81" href="#">actionpack (4.2.4) lib/action_dispatch/testing/integration.rb:32:in `get&#39;</a><br><a class="trace-frames" data-frame-id="82" href="#">lib/tasks/client_gem.rake:99:in `block (7 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="83" href="#">lib/tasks/client_gem.rake:89:in `each&#39;</a><br><a class="trace-frames" data-frame-id="84" href="#">lib/tasks/client_gem.rake:89:in `block (6 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="85" href="#">lib/tasks/client_gem.rake:74:in `each&#39;</a><br><a class="trace-frames" data-frame-id="86" href="#">lib/tasks/client_gem.rake:74:in `block (5 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="87" href="#">lib/tasks/client_gem.rake:68:in `each&#39;</a><br><a class="trace-frames" data-frame-id="88" href="#">lib/tasks/client_gem.rake:68:in `block (4 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="89" href="#">lib/tasks/client_gem.rake:67:in `each&#39;</a><br><a class="trace-frames" data-frame-id="90" href="#">lib/tasks/client_gem.rake:67:in `block (3 levels) in &lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="91" href="#">rake (11.1.1) lib/rake/task.rb:248:in `call&#39;</a><br><a class="trace-frames" data-frame-id="92" href="#">rake (11.1.1) lib/rake/task.rb:248:in `block in execute&#39;</a><br><a class="trace-frames" data-frame-id="93" href="#">rake (11.1.1) lib/rake/task.rb:243:in `each&#39;</a><br><a class="trace-frames" data-frame-id="94" href="#">rake (11.1.1) lib/rake/task.rb:243:in `execute&#39;</a><br><a class="trace-frames" data-frame-id="95" href="#">rake (11.1.1) lib/rake/task.rb:187:in `block in invoke_with_call_chain&#39;</a><br><a class="trace-frames" data-frame-id="96" href="#">/home/kratib/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/monitor.rb:211:in `mon_synchronize&#39;</a><br><a class="trace-frames" data-frame-id="97" href="#">rake (11.1.1) lib/rake/task.rb:180:in `invoke_with_call_chain&#39;</a><br><a class="trace-frames" data-frame-id="98" href="#">rake (11.1.1) lib/rake/task.rb:173:in `invoke&#39;</a><br><a class="trace-frames" data-frame-id="99" href="#">rake (11.1.1) lib/rake/application.rb:150:in `invoke_task&#39;</a><br><a class="trace-frames" data-frame-id="100" href="#">rake (11.1.1) lib/rake/application.rb:106:in `block (2 levels) in top_level&#39;</a><br><a class="trace-frames" data-frame-id="101" href="#">rake (11.1.1) lib/rake/application.rb:106:in `each&#39;</a><br><a class="trace-frames" data-frame-id="102" href="#">rake (11.1.1) lib/rake/application.rb:106:in `block in top_level&#39;</a><br><a class="trace-frames" data-frame-id="103" href="#">rake (11.1.1) lib/rake/application.rb:115:in `run_with_threads&#39;</a><br><a class="trace-frames" data-frame-id="104" href="#">rake (11.1.1) lib/rake/application.rb:100:in `top_level&#39;</a><br><a class="trace-frames" data-frame-id="105" href="#">rake (11.1.1) lib/rake/application.rb:78:in `block in run&#39;</a><br><a class="trace-frames" data-frame-id="106" href="#">rake (11.1.1) lib/rake/application.rb:176:in `standard_exception_handling&#39;</a><br><a class="trace-frames" data-frame-id="107" href="#">rake (11.1.1) lib/rake/application.rb:75:in `run&#39;</a><br><a class="trace-frames" data-frame-id="108" href="#">rake (11.1.1) bin/rake:33:in `&lt;top (required)&gt;&#39;</a><br><a class="trace-frames" data-frame-id="109" href="#">/home/kratib/.rvm/gems/ruby-2.2.1/bin/rake:23:in `load&#39;</a><br><a class="trace-frames" data-frame-id="110" href="#">/home/kratib/.rvm/gems/ruby-2.2.1/bin/rake:23:in `&lt;main&gt;&#39;</a><br></code></pre>
    </div>

  <script type="text/javascript">
    var traceFrames = document.getElementsByClassName('trace-frames');
    var selectedFrame, currentSource = document.getElementById('frame-source-0');

    // Add click listeners for all stack frames
    for (var i = 0; i < traceFrames.length; i++) {
      traceFrames[i].addEventListener('click', function(e) {
        e.preventDefault();
        var target = e.target;
        var frame_id = target.dataset.frameId;

        if (selectedFrame) {
          selectedFrame.className = selectedFrame.className.replace("selected", "");
        }

        target.className += " selected";
        selectedFrame = target;

        // Change the extracted source code
        changeSourceExtract(frame_id);
      });

      function changeSourceExtract(frame_id) {
        var el = document.getElementById('frame-source-' + frame_id);
        if (currentSource && el) {
          currentSource.className += " hidden";
          el.className = el.className.replace(" hidden", "");
          currentSource = el;
        }
      }
    }
  </script>
</div>

  

<h2 style="margin-top: 30px">Request</h2>
<p><b>Parameters</b>:</p> <pre>{&quot;format&quot;=&gt;&quot;json&quot;}</pre>

<div class="details">
  <div class="summary"><a href="#" onclick="return toggleSessionDump()">Toggle session dump</a></div>
  <div id="session_dump" style="display:none"><pre></pre></div>
</div>

<div class="details">
  <div class="summary"><a href="#" onclick="return toggleEnvDump()">Toggle env dump</a></div>
  <div id="env_dump" style="display:none"><pre>HTTP_ACCEPT: &quot;text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5&quot;
REMOTE_ADDR: &quot;127.0.0.1&quot;
SERVER_NAME: &quot;www.example.com&quot;</pre></div>
</div>

<h2 style="margin-top: 30px">Response</h2>
<p><b>Headers</b>:</p> <pre>None</pre>

</div>


<div id="console"
  data-mount-point='/__web_console'
  data-session-id='554463a8164c6b101e75e46734392ac0'
  data-prompt-label='>> '>
</div>


<script type="text/javascript">
(function() {
  /**
 * Constructor for command storage.
 * It uses localStorage if available. Otherwise fallback to normal JS array.
 */
function CommandStorage() {
  this.previousCommands = [];
  var previousCommandOffset = 0;
  var hasLocalStorage = typeof window.localStorage !== 'undefined';
  var STORAGE_KEY = "web_console_previous_commands";
  var MAX_STORAGE = 100;

  if (hasLocalStorage) {
    this.previousCommands = JSON.parse(localStorage.getItem(STORAGE_KEY)) || [];
    previousCommandOffset = this.previousCommands.length;
  }

  this.addCommand = function(command) {
    previousCommandOffset = this.previousCommands.push(command);

    if (previousCommandOffset > MAX_STORAGE) {
      this.previousCommands.splice(0, 1);
      previousCommandOffset = MAX_STORAGE;
    }

    if (hasLocalStorage) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(this.previousCommands));
    }
  };

  this.navigate = function(offset) {
    previousCommandOffset += offset;

    if (previousCommandOffset < 0) {
      previousCommandOffset = -1;
      return null;
    }

    if (previousCommandOffset >= this.previousCommands.length) {
      previousCommandOffset = this.previousCommands.length;
      return null;
    }

    return this.previousCommands[previousCommandOffset];
  }
}

// HTML strings for dynamic elements.
var consoleInnerHtml = "<div class=\'resizer layer\'><\/div>\n<div class=\'console-outer layer\'>\n  <div class=\'console-actions\'>\n    <div class=\'close-button button\' title=\'close\'>x<\/div>\n  <\/div>\n  <div class=\'console-inner\'><\/div>\n<\/div>\n<input class=\'clipboard\' type=\'text\'>\n"
;
var promptBoxHtml = "<span class=\'console-prompt-label\'><\/span>\n<pre class=\'console-prompt-display\'><\/pre>\n"
;
// CSS
var consoleStyleCss = ".console .pos-absolute { position: absolute; }\n.console .pos-fixed { position: fixed; }\n.console .pos-right { right: 0; }\n.console .border-box { box-sizing: border-box; }\n.console .layer { width: 100%; height: 100%; }\n.console .layer.console-outer { z-index: 1; }\n.console .layer.resizer { z-index: 2; }\n.console { position: fixed; left: 0; bottom: 0; width: 100%; height: 148px; padding: 0; margin: 0; background: none repeat scroll 0% 0% #333; z-index: 9999; }\n.console .console-outer { overflow: auto; padding-top: 4px; }\n.console .console-inner { font-family: monospace; font-size: 11px; width: 100%; height: 100%; overflow: none; background: #333; }\n.console .console-prompt-box { color: #FFF; }\n.console .console-message { color: #1AD027; margin: 0; border: 0; white-space: pre-wrap; background-color: #333; padding: 0; }\n.console .console-message.error-message { color: #fc9; }\n.console .console-focus .console-cursor { background: #FEFEFE; color: #333; font-weight: bold; }\n.console .resizer { background: #333; width: 100%; height: 4px; cursor: ns-resize; }\n.console .console-actions { padding-right: 3px; }\n.console .console-actions .button { float: left; }\n.console .button { cursor: pointer; border-radius: 1px; font-family: monospace; font-size: 13px; width: 14px; height: 14px; line-height: 14px; text-align: center; color: #ccc; }\n.console .button:hover { background: #666; color: #fff; }\n.console .button.close-button:hover { background: #966; }\n.console .clipboard { height: 0px; padding: 0px; margin: 0px; width: 0px; margin-left: -1000px; }\n.console .console-prompt-label { display: inline; color: #FFF; background: none repeat scroll 0% 0% #333; border: 0; padding: 0; }\n.console .console-prompt-display { display: inline; color: #FFF; background: none repeat scroll 0% 0% #333; border: 0; padding: 0; }\n.console.full-screen { height: 100%; }\n.console.full-screen .console-outer { padding-top: 3px; }\n.console.full-screen .resizer { display: none; }\n.console.full-screen .close-button { display: none; }\n"
;
// Insert a style element with the unique ID
var styleElementId = 'sr02459pvbvrmhco';

// REPLConsole Constructor
function REPLConsole(config) {
  function getConfig(key, defaultValue) {
    return config && config[key] || defaultValue;
  }

  this.commandStorage = new CommandStorage();
  this.prompt = getConfig('promptLabel', ' >>');
  this.mountPoint = getConfig('mountPoint');
  this.sessionId = getConfig('sessionId');
}

REPLConsole.prototype.getSessionUrl = function(path) {
  var parts = [ this.mountPoint, 'repl_sessions', this.sessionId ];
  if (path) {
    parts.push(path);
  }
  // Join and remove duplicate slashes.
  return parts.join('/').replace(/([^:]\/)\/+/g, '$1');
};

REPLConsole.prototype.commandHandle = function(line, callback) {
  var self = this;
  var params = 'input=' + encodeURIComponent(line);
  callback = callback || function() {};

  function isSuccess(status) {
    return status >= 200 && status < 300 || status === 304;
  }

  function parseJSON(text) {
    try {
      return JSON.parse(text);
    } catch (e) {
      return null;
    }
  }

  function getErrorText(xhr) {
    if (!xhr.status) {
      return "Oops! Failed to connect to the Web Console middleware.\nPlease make sure a rails development server is running.\n";
    } else {
      return xhr.status + ' ' + xhr.statusText;
    }
  }

  putRequest(self.getSessionUrl(), params, function(xhr) {
    var response = parseJSON(xhr.responseText);
    var result   = isSuccess(xhr.status);
    if (result) {
      self.writeOutput(response.output);
    } else {
      if (response && response.output) {
        self.writeError(response.output);
      } else {
        self.writeError(getErrorText(xhr));
      }
    }
    callback(result, response);
  });
};

REPLConsole.prototype.uninstall = function() {
  this.container.parentNode.removeChild(this.container);
};

REPLConsole.prototype.install = function(container) {
  var _this = this;

  document.onkeydown = function(ev) {
    if (_this.focused) { _this.onKeyDown(ev); }
  };

  document.onkeypress = function(ev) {
    if (_this.focused) { _this.onKeyPress(ev); }
  };

  document.addEventListener('mousedown', function(ev) {
    var el = ev.target || ev.srcElement;

    if (el) {
      do {
        if (el === container) {
          _this.focus();
          return;
        }
      } while (el = el.parentNode);

      _this.blur();
    }
  });

  // Render the console.
  container.innerHTML = consoleInnerHtml;

  var consoleOuter = findChild(container, 'console-outer');
  var consoleActions = findChild(consoleOuter, 'console-actions');

  addClass(container, 'console');
  addClass(container.getElementsByClassName('layer'), 'pos-absolute border-box');
  addClass(container.getElementsByClassName('button'), 'border-box');
  addClass(consoleActions, 'pos-fixed pos-right');

  // Make the console resizable.
  function resizeContainer(ev) {
    var startY              = ev.clientY;
    var startHeight         = parseInt(document.defaultView.getComputedStyle(container).height, 10);
    var scrollTopStart      = consoleOuter.scrollTop;
    var clientHeightStart   = consoleOuter.clientHeight;

    var doDrag = function(e) {
      container.style.height = (startHeight + startY - e.clientY) + 'px';
      consoleOuter.scrollTop = scrollTopStart + (clientHeightStart - consoleOuter.clientHeight);
      shiftConsoleActions();
    };

    var stopDrag = function(e) {
      document.documentElement.removeEventListener('mousemove', doDrag, false);
      document.documentElement.removeEventListener('mouseup', stopDrag, false);
    };

    document.documentElement.addEventListener('mousemove', doDrag, false);
    document.documentElement.addEventListener('mouseup', stopDrag, false);
  }

  function closeContainer(ev) {
    container.parentNode.removeChild(container);
  }

  var shifted = false;
  function shiftConsoleActions() {
    if (consoleOuter.scrollHeight > consoleOuter.clientHeight) {
      var widthDiff = document.documentElement.clientWidth - consoleOuter.clientWidth;
      if (shifted || ! widthDiff) return;
      shifted = true;
      consoleActions.style.marginRight = widthDiff + 'px';
    } else if (shifted) {
      shifted = false;
      consoleActions.style.marginRight = '0px';
    }
  }

  // Initialize
  this.container = container;
  this.outer = consoleOuter;
  this.inner = findChild(this.outer, 'console-inner');
  this.clipboard = findChild(container, 'clipboard');
  this.newPromptBox();
  this.insertCss();

  findChild(container, 'resizer').addEventListener('mousedown', resizeContainer);
  findChild(consoleActions, 'close-button').addEventListener('click', closeContainer);
  consoleOuter.addEventListener('DOMNodeInserted', shiftConsoleActions);

  REPLConsole.currentSession = this;
};

// Add CSS styles dynamically. This probably doesnt work for IE <8.
REPLConsole.prototype.insertCss = function() {
  if (document.getElementById(styleElementId)) {
    return; // already inserted
  }
  var style = document.createElement('style');
  style.type = 'text/css';
  style.innerHTML = consoleStyleCss;
  style.id = styleElementId;
  document.getElementsByTagName('head')[0].appendChild(style);
};

REPLConsole.prototype.focus = function() {
  if (! this.focused) {
    this.focused = true;
    if (! hasClass(this.inner, "console-focus")) {
      addClass(this.inner, "console-focus");
    }
    this.scrollToBottom();
  }
};

REPLConsole.prototype.blur = function() {
  this.focused = false;
  removeClass(this.inner, "console-focus");
};

/**
 * Add a new empty prompt box to the console.
 */
REPLConsole.prototype.newPromptBox = function() {
  // Remove the caret from previous prompt display if any.
  if (this.promptDisplay) {
    this.removeCaretFromPrompt();
  }

  var promptBox = document.createElement('div');
  promptBox.className = "console-prompt-box";
  promptBox.innerHTML = promptBoxHtml;
  this.promptLabel = promptBox.getElementsByClassName('console-prompt-label')[0];
  this.promptDisplay = promptBox.getElementsByClassName('console-prompt-display')[0];
  // Render the prompt box
  this.setInput("");
  this.promptLabel.innerHTML = this.prompt;
  this.inner.appendChild(promptBox);
  this.scrollToBottom();
};

/**
 * Remove the caret from the prompt box,
 * mainly before adding a new prompt box.
 * For simplicity, just re-render the prompt box
 * with caret position -1.
 */
REPLConsole.prototype.removeCaretFromPrompt = function() {
  this.setInput(this._input, -1);
};

REPLConsole.prototype.setInput = function(input, caretPos) {
  this._caretPos = caretPos === undefined ? input.length : caretPos;
  this._input = input;
  this.renderInput();
};

/**
 * Add some text to the existing input.
 */
REPLConsole.prototype.addToInput = function(val, caretPos) {
  caretPos = caretPos || this._caretPos;
  var before = this._input.substring(0, caretPos);
  var after = this._input.substring(caretPos, this._input.length);
  var newInput =  before + val + after;
  this.setInput(newInput, caretPos + val.length);
};

/**
 * Render the input prompt. This is called whenever
 * the user input changes, sometimes not very efficient.
 */
REPLConsole.prototype.renderInput = function() {
  // Clear the current input.
  removeAllChildren(this.promptDisplay);

  var promptCursor = document.createElement('span');
  promptCursor.className = "console-cursor";
  var before, current, after;

  if (this._caretPos < 0) {
    before = this._input;
    current = after = "";
  } else if (this._caretPos === this._input.length) {
    before = this._input;
    current = "\u00A0";
    after = "";
  } else {
    before = this._input.substring(0, this._caretPos);
    current = this._input.charAt(this._caretPos);
    after = this._input.substring(this._caretPos + 1, this._input.length);
  }

  this.promptDisplay.appendChild(document.createTextNode(before));
  promptCursor.appendChild(document.createTextNode(current));
  this.promptDisplay.appendChild(promptCursor);
  this.promptDisplay.appendChild(document.createTextNode(after));
};

REPLConsole.prototype.writeOutput = function(output) {
  var consoleMessage = document.createElement('pre');
  consoleMessage.className = "console-message";
  consoleMessage.innerHTML = escapeHTML(output);
  this.inner.appendChild(consoleMessage);
  this.newPromptBox();
  return consoleMessage;
};

REPLConsole.prototype.writeError = function(output) {
  var consoleMessage = this.writeOutput(output);
  addClass(consoleMessage, "error-message");
  return consoleMessage;
};

REPLConsole.prototype.onEnterKey = function() {
  var input = this._input;

  if(input != "" && input !== undefined) {
    this.commandStorage.addCommand(input);
  }

  this.commandHandle(input);
};

REPLConsole.prototype.onNavigateHistory = function(offset) {
  var command = this.commandStorage.navigate(offset) || "";
  this.setInput(command);
};

/**
 * Handle control keys like up, down, left, right.
 */
REPLConsole.prototype.onKeyDown = function(ev) {
  switch (ev.keyCode) {
    case 13:
      // Enter key
      this.onEnterKey();
      ev.preventDefault();
      break;
    case 80:
      // Ctrl-P
      if (! ev.ctrlKey) break;
    case 38:
      // Up arrow
      this.onNavigateHistory(-1);
      ev.preventDefault();
      break;
    case 78:
      // Ctrl-N
      if (! ev.ctrlKey) break;
    case 40:
      // Down arrow
      this.onNavigateHistory(1);
      ev.preventDefault();
      break;
    case 37:
      // Left arrow
      var caretPos = this._caretPos > 0 ? this._caretPos - 1 : this._caretPos;
      this.setInput(this._input, caretPos);
      ev.preventDefault();
      break;
    case 39:
      // Right arrow
      var length = this._input.length;
      var caretPos = this._caretPos < length ? this._caretPos + 1 : this._caretPos;
      this.setInput(this._input, caretPos);
      ev.preventDefault();
      break;
    case 8:
      // Delete
      this.deleteAtCurrent();
      ev.preventDefault();
      break;
    default:
      break;
  }

  if (ev.ctrlKey || ev.metaKey) {
    // Set focus to our clipboard in case they hit the "v" key
    this.clipboard.focus();
    if (ev.keyCode == 86) {
      // Pasting to clipboard doesn't happen immediately,
      // so we have to wait for a while to get the pasted text.
      var _this = this;
      setTimeout(function() {
        _this.addToInput(_this.clipboard.value);
        _this.clipboard.value = "";
        _this.clipboard.blur();
      }, 10);
    }
  }

  ev.stopPropagation();
};

/**
 * Handle input key press.
 */
REPLConsole.prototype.onKeyPress = function(ev) {
  // Only write to the console if it's a single key press.
  if (ev.ctrlKey || ev.metaKey) { return; }
  var keyCode = ev.keyCode || ev.which;
  this.insertAtCurrent(String.fromCharCode(keyCode));
  ev.stopPropagation();
  ev.preventDefault();
};

/**
 * Delete a character at the current position.
 */
REPLConsole.prototype.deleteAtCurrent = function() {
  if (this._caretPos > 0) {
    var caretPos = this._caretPos - 1;
    var before = this._input.substring(0, caretPos);
    var after = this._input.substring(this._caretPos, this._input.length);
    this.setInput(before + after, caretPos);
  }
};

/**
 * Insert a character at the current position.
 */
REPLConsole.prototype.insertAtCurrent = function(char) {
  var before = this._input.substring(0, this._caretPos);
  var after = this._input.substring(this._caretPos, this._input.length);
  this.setInput(before + char + after, this._caretPos + 1);
};

REPLConsole.prototype.scrollToBottom = function() {
  this.outer.scrollTop = this.outer.scrollHeight;
};

// Change the binding of the console
REPLConsole.prototype.switchBindingTo = function(frameId, callback) {
  var url = this.getSessionUrl('trace');
  var params = "frame_id=" + encodeURIComponent(frameId);
  postRequest(url, params, callback);
};

/**
 * Install the console into the element with a specific ID.
 * Example: REPLConsole.installInto("target-id")
 */
REPLConsole.installInto = function(id, options) {
  var consoleElement = document.getElementById(id);

  options = options || {};

  for (var prop in consoleElement.dataset) {
    options[prop] = options[prop] || consoleElement.dataset[prop];
  }

  var replConsole = new REPLConsole(options);
  replConsole.install(consoleElement);
  return replConsole;
};

// This is to store the latest single session, and the stored session
// is updated by the REPLConsole#install() method.
// It allows to operate the current session from the other scripts.
REPLConsole.currentSession = null;

// This line is for the Firefox Add-on, because it doesn't have XMLHttpRequest as default.
// And so we need to require a module compatible with XMLHttpRequest from SDK.
REPLConsole.XMLHttpRequest = typeof XMLHttpRequest === 'undefined' ? null : XMLHttpRequest;

REPLConsole.request = function request(method, url, params, callback) {
  var xhr = new REPLConsole.XMLHttpRequest();

  xhr.open(method, url, true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
  xhr.setRequestHeader("Accept", "application/vnd.web-console.v2");
  xhr.send(params);

  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
      callback(xhr);
    }
  };
};

// DOM helpers
function hasClass(el, className) {
  var regex = new RegExp('(?:^|\\s)' + className + '(?!\\S)', 'g');
  return el.className && el.className.match(regex);
}

function isNodeList(el) {
  return typeof el.length === 'number' &&
    typeof el.item === 'function';
}

function addClass(el, className) {
  if (isNodeList(el)) {
    for (var i = 0; i < el.length; ++ i) {
      addClass(el[i], className);
    }
  } else {
    el.className += " " + className;
  }
}

function removeClass(el, className) {
  var regex = new RegExp('(?:^|\\s)' + className + '(?!\\S)', 'g');
  el.className = el.className.replace(regex, '');
}

function removeAllChildren(el) {
  while (el.firstChild) {
    el.removeChild(el.firstChild);
  }
}

function findChild(el, className) {
  for (var i = 0; i < el.childNodes.length; ++ i) {
    if (hasClass(el.childNodes[i], className)) {
      return el.childNodes[i];
    }
  }
}

function escapeHTML(html) {
  return html
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
    .replace(/`/g, '&#x60;');
}

// XHR helpers
function postRequest() {
  REPLConsole.request.apply(this, ["POST"].concat([].slice.call(arguments)));
}

function putRequest() {
  REPLConsole.request.apply(this, ["PUT"].concat([].slice.call(arguments)));
}

if (typeof exports === 'object') {
  exports.REPLConsole = REPLConsole;
} else {
  window.REPLConsole = REPLConsole;
}

}).call(this);
</script>

<script type="text/javascript">
(function() {
  REPLConsole.installInto('console');

}).call(this);
</script>


  <script type="text/javascript">
(function() {
  // Try intercept traces links in Rails 4.2.
var traceFrames = document.getElementsByClassName('trace-frames');
var selectedFrame, currentSource = document.getElementById('frame-source-0');

// Add click listeners for all stack frames
for (var i = 0; i < traceFrames.length; i++) {
  traceFrames[i].addEventListener('click', function(e) {
    e.preventDefault();
    var target = e.target;
    var frameId = target.dataset.frameId;

    // Change the binding of the console.
    changeBinding(frameId, function() {
      if (selectedFrame) {
        selectedFrame.className = selectedFrame.className.replace("selected", "");
      }

      target.className += " selected";
      selectedFrame = target;
    });

    // Change the extracted source code
    changeSourceExtract(frameId);
  });
}

function changeBinding(frameId, callback) {
  REPLConsole.currentSession.switchBindingTo(frameId, callback);
}

function changeSourceExtract(frameId) {
  var el = document.getElementById('frame-source-' + frameId);
  if (currentSource && el) {
    currentSource.className += " hidden";
    el.className = el.className.replace(" hidden", "");
    currentSource = el;
  }
}

// Push the error page body upwards the size of the console.
//
// While, I wouldn't like to do that on every custom page (so I don't screw
// user's layouts), I think a lot of developers want to see all of the content
// on the default Rails error page.
//
// Since it's quite special as is now, being a bit more special in the name of
// better user experience, won't hurt.
document.addEventListener('DOMContentLoaded', function() {
  var consoleElement = document.getElementById('console');
  var resizerElement = consoleElement.getElementsByClassName('resizer')[0];
  var containerElement = document.getElementById('container');

  function setContainerElementBottomMargin(pixels) {
    containerElement.style.marginBottom = pixels + 'px';
  }

  var currentConsoleElementHeight = consoleElement.offsetHeight;
  setContainerElementBottomMargin(currentConsoleElementHeight);

  resizerElement.addEventListener('mousedown', function(event) {
    function recordConsoleElementHeight(event) {
      resizerElement.removeEventListener('mouseup', recordConsoleElementHeight);

      var currentConsoleElementHeight = consoleElement.offsetHeight;
      setContainerElementBottomMargin(currentConsoleElementHeight);
    }

    resizerElement.addEventListener('mouseup', recordConsoleElementHeight);
  });
});

}).call(this);
</script>

</body>
</html>', status: 400)
      @data = nil
      yield
      WebMock.allow_net_connect!
    end
             
    def self.mock_languages_classify_returns_access_denied(host = nil)
      WebMock.disable_net_connect!
      host ||= LangidClient.host
      WebMock.stub_request(:get, host + '/api/languages/classify')
      .with({:query=>{:text=>"Test"}})
      .to_return(body: '{"type":"error","data":{"message":"Unauthorized","code":1}}', status: 401)
      @data = {"type"=>"error", "data"=>{"message"=>"Unauthorized", "code"=>1}}
      yield
      WebMock.allow_net_connect!
    end
             
  end
end