require 'net/http'
require 'uri'
require 'nokogiri'


$url_template = "https://www.biblegateway.com/passage/?search=%{ref}&version=NIV"

references = ['1 Timothy 3:1-15'].map { |r| r.gsub(/\s/, '+') }

ref = references.first
uri = URI.parse($url_template % {ref: ref})
response = Net::HTTP.get_response uri


page = Nokogiri::HTML(response.body)

spans = page.css('div.passage-text span')


versus = spans.map do |s|
  verse_number = s.attr('class').scan(/\d+$/)
  "#{verse_number}. #{s.text}"
end

File.write("./regex/sanitized/content.txt", versus.join("\n"))
