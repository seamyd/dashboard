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
      api.service_status(service_status_types: :critical).reject{ |s| s.acknowledged }
    end

    def warnings
      api.service_status(service_status_types: :warning)
    end
  end
end
