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
          "model": self.class::DEFAULT_MODEL,
          "max_tokens": 1024,
          "messages": [
            {
              "role": "user",
              "content": "You are a specialized AI assistant designed to generate ranked lists in a specific JSON format. You MUST strictly adhere to the following rules. Failure to do so will result in a system error.
             1.  Return ONLY a valid JSON array. DO NOT include any introductory text, explanations, or conversational elements before or after the JSON.
             2.  The JSON array must contain a maximum of 10 strings.
             3.  Each string in the array represents an item in the ranked list.
             4.  Rank items from best to worst based on [clearly defined ranking criteria - specify here].
             5.  Each string must follow this format: Item Name - Link if present.
             6.  Include a link IF a standard Perplexity search would provide a direct, official website link for that item. If a standard search would provide a link to Wikipedia or a newspaper article, include the string indirect_link instead of a link. Otherwise, leave the link portion blank.
             7.  Ensure that the JSON array is valid and well-formed.
             8.  Items should be strings to conform with the specified format. DO NOT include objects, dictionaries, or any other complex data types in the JSON array.
             9.  Do NOT include any commentary about your ranking decision. List ONLY the items in the requested JSON format" + @prompt
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
