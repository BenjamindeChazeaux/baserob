module Ai
  module Models
    class OpenAi < Request
      API_URL = 'https://api.openai.com/v1/chat/completions'
      DEFAULT_MODEL = 'gpt-4o-mini'
      API_KEY = ENV['OPENAI_API_KEY']

      private

      def headers
        {
          'Authorization' => "Bearer #{self.class::API_KEY}",
          'Content-Type' => 'application/json'
        }
      end

      def body
        {
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": "give me the answer only with a list "
            },
            {
              "role": "user",
              "content": @prompt
            }
          ]
        }
      end

      def extract_content(response)
        response.dig('choices', 0, 'message', 'content')
      end
    end
  end
end
