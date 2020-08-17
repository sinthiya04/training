require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'byebug'
$url_template = "https://www.biblegateway.com/passage/?search=%{ref}&version=NIV"


$books = "Genesis|Exodus|Leviticus|Numbers|Deuteronomy|Joshua|Judges|Ruth|Samuel|Kings|Chronicles|Ezra|Nehemiah|Esther|Job|Psalms|Proverbs|Ecclesiastes|Song of Solomon|Isaiah|Jeremiah|Lamentations|Ezekiel|Daniel|Hosea|Joel|Amos|Obadiah|Jonah|Micah|Nahum|Habakkuk|Zephaniah|Haggai|Zechariah|Malachi|Matthew|Mark|Luke|John|Acts|Romans|Corinthians|Galatians|Ephesians|Philippians|Colossians|Thessalonians|Timothy|Titus|Philemon|Hebrews|James|Peter|John|Jude|Revelation"

def each_file_in_santized
  files = Dir.entries("./regex/sanitized").select {|n| n.include?(".txt")}
  files.each {|f| yield(f, File.read("./regex/sanitized/#{f}"))}
end

def sanitize_passages
  files = Dir.entries("./regex/passages").select { |n| n.include?(".txt") }
  files.each do |fname|
    verses = File.read("./regex/passages/#{fname}")
    verses = verses.gsub(/[(][A-Z]+[)]/, '')
    verses = verses.gsub(/\[.\]/, '')
    verses = verses.gsub(/\.\,\s+/, '.')
    verses = verses.gsub(/\,/, '')
    verses = verses.gsub(/\"/, '')
    verses = verses.gsub(/(\d)+(\s)/, '\n\1\2')
    File.write("./regex/fetch_verse/#{fname}", verses)
  end
end


def fetch_from_bible_gateway(ref)
  uri = URI.parse($url_template % {ref: ref})
  response = Net::HTTP.get_response uri
  page = Nokogiri::HTML(response.body)
  spans = page.css('div.passage-text span')
    versus = spans.map do |s|
      verse_number = s.attr('class').scan(/\d+$/)
      verse = verse_number[0].to_s
      "#{s.text}"
    end
end

def fetch_passages
  each_file_in_santized do |filename, content|
    puts "Reading file #{filename}"
    references = content.scan(/\w+ \d+:\d+-\d+|\w+ \d+:\d+|I \w+ \d+:\d+-\d+|I \w+ \d+:\d+/).flatten
    puts "Found #{references.count} references..."
    #puts references if(filename == 'Inter_ENGHB_L1.txt' 'Inter_ENGHB_L2.txt' 'Inter_ENGHB_L3.txt')
    File.open("./regex/passages/#{filename}", "w") do |file|
      references.each do |rf|
        puts "#{rf}"
          passage = fetch_from_bible_gateway(rf)
          file.write("#{rf}\n#{passage}\n")      
      end
    end
    puts "Completed file #{filename}"
  end
end
fetch_passages
