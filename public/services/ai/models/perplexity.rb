module Ai
  module Models
    class Perplexity < Request
      API_URL = 'https://api.perplexity.ai/chat/completions'
      DEFAULT_MODEL = 'sonar'
      API_KEY = ENV['PERPLEXITY_API_KEY']

      private

      def headers
        {
          'Authorization' => "Bearer #{API_KEY}"
        }
      end

      def body
        {
          "model": self.class::DEFAULT_MODEL,
          "messages": [
            {
              "role": "system",
              "content": "Answer me in a table of 10 only a list not even a sentence "
            },"
            },
            {
              "role": "user",
              "content": @prompt
            }
          ],
          # "max_tokens": 123,
          # "temperature": 0.2,
          # "top_p": 0.9,
          # "search_domain_filter": null,
          # "return_images": false,
          # "return_related_questions": false,
          # "search_recency_filter": "<string>",
          # "top_k": 0,
          # "stream": false,
          # "presence_penalty": 0,
          # "frequency_penalty": 1,
          # "response_format": null
        }
      end

      def extract_content(response)
        response.dig('choices', 0, 'message', 'content')
      end
    end
  end
end
