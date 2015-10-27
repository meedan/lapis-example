# :nocov:
module LanguagesDoc
  extend ActiveSupport::Concern
 
  included do
    swagger_controller :languages, 'Languages'

    swagger_api :classify do
      summary 'Send some text to be classified'
      notes 'Use this method in order to identify the language of a given text'
      param :query, :text, :string, :required, 'Text to be classified'
      # response(code, message, exampleRequest)
      # "exampleRequest" should be: { query: {}, headers: {}, body: {} }
      authed = { 'Authorization' => 'Token token="test"' }
      response :ok, 'Text language', { query: { text: 'The book is on the table' }, headers: authed }
      response 400, 'Parameter "text" is missing', { query: nil, headers: authed }
      response 401, 'Access denied', { query: { text: 'Test' } }
    end
  end
end
# :nocov:
