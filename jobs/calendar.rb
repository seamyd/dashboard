require 'open-uri'
require 'nokogiri'
require 'date'
require 'cgi'

class Calendar < Dashing::Job

	private

	def get_todays_events_from_calendar(url)
		events = Array.new
		date = DateTime.now
		
		uri =  URI.parse(url)
		new_query_arr = ["min", DateTime.new(date.year, date.month, date.day).to_s] << ["max", DateTime.new(date.year, date.month, date.day, 23, 59, 59).to_s]
		uri.query = URI.encode_www_form(new_query_arr)
		
		url += uri.to_s
		reader = Nokogiri::XML(open(url))
		reader.remove_namespaces!
		reader.xpath("//feed/entry").each do |e|
			title = e.at_xpath("./title").text
			content = e.at_xpath("./content").text
			when_node = e.at_xpath("./when")
			events.push({title: title,
				body: content ? content : "",
				when_start_raw: when_node ? DateTime.iso8601(when_node.attribute('startTime').text).to_time.to_i : 0,
				when_end_raw: when_node   ? DateTime.iso8601(when_node.attribute('endTime').text).to_time.to_i   : 0,
				when_start: when_node     ? DateTime.iso8601(when_node.attribute('startTime').text).to_time      : "No time",
				when_end: when_node       ? DateTime.iso8601(when_node.attribute('endTime').text).to_time        : "No time"
			})
		end
		events.sort! {|a,b| a[:when_start_raw] <=> b[:when_start_raw] }
		events = events[0,2]
		events.delete_if {|event| DateTime.now().to_time.to_i>=event[:when_end_raw]}

		events
	end

	def events_to_text(events)
		titles = []
		events.each do |ev|
			titles.push ev[:title]
		end
		text = titles.join " -- "
		if text.length > 40
			text = text[0, 40]
		end
		text
	end

	public

	def do_execute
		calendar_url = ENV['CALENDAR']

		events = get_todays_events_from_calendar calendar_url
		text = events_to_text(events)

		{events: text}
	end
end