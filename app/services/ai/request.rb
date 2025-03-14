# frozen_string_literal: true

module Ai
  class Request < ApplicationService
    class ConfigurationError < StandardError; end
    class RequestError < StandardError; end

    def initialize(prompt, model: self.class::DEFAULT_MODEL)
      @prompt = prompt
      @model = model
    end

    def call
      options = {
        headers: { 'Content-Type' => 'application/json' }.merge(headers),
        body: request_body(@prompt).to_json
      }

      begin
        response = HTTParty.post(self.class::API_URL, options)
        handle_response(response)
      rescue StandardError => e
        handle_error(e)
      end
    end

    private

    def headers
      raise NotImplementedError, 'Subclasses must implement the auth_headers method'
    end

    def request_body(prompt)
      {
        model: @model,
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.7
      }
    end

    def handle_response(response)
      if response.success?
        parsed_response = JSON.parse(response.body)
        extract_content(parsed_response)
      else
        raise RequestError, "#{self.class.name} API error: #{response.code} - #{response.message} (#{response.dig('error', 'message')})"
      end
    end

    def handle_error(error)
      raise RequestError, "#{self.class.name} API request failed: #{error.message}"
    end
  end
end
