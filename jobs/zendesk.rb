require 'httparty'

class Zendesk < Dashing::Job
  class Counter
    def initialize(config)
      @notice  = Zendesk.view_count(config[:notice])
      @warning = Zendesk.view_count(config[:warning])
    end

    def execute
      { warningNumber: @warning, noticeNumber: @notice }
    end
  end

  class Issues
    def initialize(config)
      @config = config
    end

    def tickets
      @config[:views].each_with_object([]) do |(label, view_id), array|
        array << { label: label, value: Zendesk.view_count(view_id) }
      end.sort_by{ |hash| hash[:value] }.reverse!
    end

    def execute
      { items: tickets }
    end
  end

protected

  def do_execute
    Zendesk.const_get(config[:type]).new(config).execute
  end

  class << self

    def api_request(api_endpoint)
      auth = {username: ENV['ZD_USER'], password: ENV['ZD_PASS']}
      request = "https://#{ENV['ZD_HOST']}/api/v2/#{api_endpoint}"
      api_response = HTTParty.get(request, basic_auth: auth)
      JSON.parse(api_response.body)
    rescue Timeout::Error
      $stdout.write "[WARN] Timeout to service #{request}\n"
    rescue Errno::ECONNREFUSED
      $stdout.write "[WARN] Connection refused. Check your credentials. #{request}\n"
    end

    def view_count(view_id)
      api_request("views/#{view_id}/count.json")['view_count']['value'] rescue ''
    end
  end
end
