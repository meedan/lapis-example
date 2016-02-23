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
        request['X-Lapis-Example-Token'] = token.to_s
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
      .with({:query=>{:text=>"The book is on the table"}, :headers=>{"X-Lapis-Example-Token"=>"test"}})
      .to_return(body: '{"type":"language","data":"english"}', status: 200)
      @data = {"type"=>"language", "data"=>"english"}
      yield
      WebMock.allow_net_connect!
    end
           
    def self.mock_languages_classify_returns_parameter_text_is_missing(host = nil)
      WebMock.disable_net_connect!
      host ||= LangidClient.host
      WebMock.stub_request(:get, host + '/api/languages/classify')
      .with({:query=>nil, :headers=>{"X-Lapis-Example-Token"=>"test"}})
      .to_return(body: '{"type":"error","data":{"message":"Parameters missing","code":2}}', status: 400)
      @data = {"type"=>"error", "data"=>{"message"=>"Parameters missing", "code"=>2}}
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
