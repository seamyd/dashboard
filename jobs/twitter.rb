require 'net/http'
require 'json'

class TwitterSearch < Dashing::Job

  protected

  def do_execute
    search_string = config.each_with_object([]) do |(param, value), array|
      array << "#{param}=#{value}"
    end.join('&')

    http = Net::HTTP.new('search.twitter.com')
    response = http.request(Net::HTTP::Get.new("/search.json?#{URI::encode(search_string)}"))
    tweets = JSON.parse(response.body)['results']

    if tweets
      tweets.map! do |tweet|
        { name: tweet['from_user'], body: tweet['text'], avatar: tweet['profile_image_url_https'] }
      end

      return { comments: tweets }
    end
  end
end
