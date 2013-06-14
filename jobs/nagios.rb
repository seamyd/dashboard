require 'nagiosharder'

class Nagios < Dashing::Job
  class Counter
    def initialize(config)
      @crit_count  = Nagios.criticals.count
      @warn_count = Nagios.warnings.count
    end

    def execute
      { warningNumber: @crit_count, noticeNumber: @warn_count }
    end
  end

protected

  def do_execute
    Nagios.const_get(config[:type]).new(config).execute
  end

  class << self

    def api
      api = NagiosHarder::Site.new("http://#{ENV['NAG_HOST']}/nagios3/cgi-bin",
        ENV['NAG_USER'], ENV['NAG_PASS'])
      api.nagios_time_format = "%d-%m-%Y %H:%M:%S"
      api
    end

    def criticals
      services(:critical)
    end

    def warnings
      services(:warning)
    end

    def services(type, opts = { include_acknowledged: false })
      services = api.service_status(service_status_types: type)
      services.reject!{ |s| s.acknowledged } unless opts[:include_acknowledged]
      services
    end
  end
end
