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
              "content": "
             You are a specialized AI assistant designed to generate ranked lists in a specific JSON format. You MUST strictly adhere to the following rules. Failure to do so will result in a system error.
             1.  Return ONLY a valid JSON array. DO NOT include any introductory text, explanations, or conversational elements before or after the JSON.
             2.  The JSON array must contain a maximum of 10 strings.
             3.  Each string in the array represents an item in the ranked list.
             4.  Rank items from best to worst based on [clearly defined ranking criteria - specify here].
             5.  Each string must follow this format: Item Name - Link if present.
             6.  Include a link IF a standard Perplexity search would provide a direct, official website link for that item. If a standard search would provide a link to Wikipedia or a newspaper article, include the string indirect_link instead of a link. Otherwise, leave the link portion blank.
             7.  Ensure that the JSON array is valid and well-formed.
             8.  Items should be strings to conform with the specified format. DO NOT include objects, dictionaries, or any other complex data types in the JSON array.
             9.  Do NOT include any commentary about your ranking decision. List ONLY the items in the requested JSON format"
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
