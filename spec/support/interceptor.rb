# frozen_string_literal: true

module Interceptor
  def intercept(url, response = '', method = :any)
    @interceptions << { url:, method:, response: }
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def start_intercepting
    # ignore if the driver is RackTest
    return unless page.driver.browser.respond_to?(:intercept)

    # only attach the intercept callback once to the browser
    @interceptions = default_interceptions

    return if @intercepting

    page.driver.browser.intercept do |request, &continue|
      url = request.url
      method = request.method

      if (interception = response_for(url, method))
        # set mocked body if there's an interception for the url and method
        continue.call(request) do |response|
          response.body = interception[:response]
        end
      elsif allowed_request?(url, method)
        # leave request untouched if allowed
        continue.call(request)
      else
        # intercept any external request with an empty response and print some logs
        continue.call(request) do |response|
          log_request(url, method)
          response.body = ''
        end
      end
    end
    @intercepting = true
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def stop_intercepting
    return unless @intercepting

    # remove the callback, cleanup
    clear_devtools_intercepts
    @intercepting = false
    # some requests may finish after the test is done if we let them go through untouched
    sleep(0.2)
  end

  def default_interceptions
    [
      {
        url: %r{api.github.com/\w*},
        method: :get,
        response: { files: { testgist: { content: 'mocked test gist' } } }.to_json
      }
    ]
  end

  def allowed_requests
    [%r{http://#{Capybara.server_host}}]
  end

  private

  # check if the given request url and http method pair is allowed by any rule
  def allowed_request?(url, method = 'GET')
    allowed_requests.any? do |allowed|
      allowed_url = allowed.is_a?(Hash) ? allowed[:url] : allowed
      matches_url = url.match?(allowed_url)

      allowed_method = allowed.is_a?(Hash) ? allowed[:method] : :any
      allowed_method ||= :any
      matches_method = allowed_method == :any || method == allowed_method.to_s.upcase

      matches_url && matches_method
    end
  end

  # find the interception hash for a given url and http method pair
  def response_for(url, method = 'GET')
    @interceptions.find do |interception|
      matches_url = url.match?(interception[:url])
      intercepted_method = interception[:method] || :any
      matches_method = intercepted_method == :any || method == intercepted_method.to_s.upcase

      matches_url && matches_method
    end
  end

  # clears the devtools callback for the interceptions
  def clear_devtools_intercepts
    callbacks = page.driver.browser.devtools.callbacks
    callbacks.delete('Fetch.requestPaused') if callbacks.key?('Fetch.requestPaused')
  end

  def log_request(url, method)
    message = "External JavaScript request not intercepted: #{method} #{url}"
    puts message
    Rails.logger.warn message
  end
end
