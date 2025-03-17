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
              "content": "You are a specialized AI assistant designed to generate ranked lists in a specific JSON format. You MUST strictly adhere to the following rules. Failure to do so will result in a system error.
             1.  Return ONLY a valid JSON array. DO NOT include any introductory text, explanations, or conversational elements before or after the JSON.
             2.  The JSON array must contain a maximum of 10 strings.
             3.  Each string in the array represents an item in the ranked list.
             4.  Rank items from best to worst based on [clearly defined ranking criteria - specify here].
             5.  Each string must follow this format: Item Name - Link if present.
             6.  Include a link IF a standard Perplexity search would provide a direct, official website link for that item.Otherwise, leave the link portion blank.
             7.  Ensure that the JSON array is valid and well-formed.
             8.  Items should be strings to conform with the specified format. DO NOT include objects, dictionaries, or any other complex data types in the JSON array.
             9.  Do NOT include any commentary about your ranking decision. List ONLY the items in the requested JSON format"
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
