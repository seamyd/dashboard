require 'net/http'
require 'xmlsimple'

class Weather < Dashing::Job
  def do_execute
  end

  def execute
    locations.each do |element, woeid|
      http = Net::HTTP.new('weather.yahooapis.com')
      response = http.request(Net::HTTP::Get.new("/forecastrss?w=#{woeid}&u=c"))
      weather_data = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['item']['condition']
      weather_location = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['location']
      send_event(element, { :temp => weather_data['temp'],
                              :condition => weather_data['text'],
                              :climacon => climacon_class(weather_data['code'])})
    end
  end

protected

  def locations
    Sinatra::Application.config[:dashboards].each_with_object({}) do |(_,d),hash|
      d[:widgets].select do |widget|
        widget[:view] == 'Weather'
      end.map{ |h| hash[h[:event]] = h[:woeid] }
    end
  end

  def climacon_class(weather_code)
    case weather_code.to_i
    when 0
      'tornado'
    when 1
      'tornado'
    when 2
      'tornado'
    when 3
      'lightning'
    when 4
      'lightning'
    when 5
      'snow'
    when 6
      'sleet'
    when 7
      'snow'
    when 8
      'drizzle'
    when 9
      'drizzle'
    when 10
      'sleet'
    when 11
      'rain'
    when 12
      'rain'
    when 13
      'snow'
    when 14
      'snow'
    when 15
      'snow'
    when 16
      'snow'
    when 17
      'hail'
    when 18
      'sleet'
    when 19
      'haze'
    when 20
      'fog'
    when 21
      'haze'
    when 22
      'haze'
    when 23
      'wind'
    when 24
      'wind'
    when 25
      'thermometer low'
    when 26
      'cloud'
    when 27
      'cloud moon'
    when 28
      'cloud sun'
    when 29
      'cloud moon'
    when 30
      'cloud sun'
    when 31
      'moon'
    when 32
      'sun'
    when 33
      'moon'
    when 34
      'sun'
    when 35
      'hail'
    when 36
      'thermometer full'
    when 37
      'lightning'
    when 38
      'lightning'
    when 39
      'lightning'
    when 40
      'rain'
    when 41
      'snow'
    when 42
      'snow'
    when 43
      'snow'
    when 44
      'cloud'
    when 45
      'lightning'
    when 46
      'snow'
    when 47
      'lightning'
    end
  end
end
