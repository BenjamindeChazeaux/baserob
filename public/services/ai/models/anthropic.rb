module Ai
  module Models
    class Anthropic < Request
      API_URL = 'https://api.anthropic.com/v1/messages'
      DEFAULT_MODEL = 'claude-3-5-haiku-20241022'
      API_KEY = ENV['ANTHROPIC_API_KEY']

      private

      def headers
        {
          'x-api-key' => API_KEY,
          'anthropic-version' => '2023-06-01'
        }
      end

      def body
        {
          "model": @model,
          "max_tokens": 1024,
          "messages": [
            {
              "role": "user",
              "content": @prompt
            }
          ]
        }
      end

      def extract_content(response)
        response.dig('content', 0, 'text')
      end
    end
  end
end
