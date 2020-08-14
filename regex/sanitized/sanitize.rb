

$books = "Genesis|Exodus|Leviticus|Numbers|Deuteronomy|Joshua|Judges|Ruth|Samuel|Kings|Chronicles|Ezra|Nehemiah|Esther|Job|Psalms|Proverbs|Ecclesiastes|Song of Solomon|Isaiah|Jeremiah|Lamentations|Ezekiel|Daniel|Hosea|Joel|Amos|Obadiah|Jonah|Micah|Nahum|Habakkuk|Zephaniah|Haggai|Zechariah|Malachi|Matthew|Mark|Luke|John|Acts|Romans|Corinthians|Galatians|Ephesians|Philippians|Colossians|Thessalonians|Timothy|Titus|Philemon|Hebrews|James|Peter|John|Jude|Revelation"
def sanitize
  files = Dir.entries("./regex/artifacts").select {|n| n.include?(".txt")}

  files.each do |fname|
    content = File.read("./regex/artifacts/#{fname}")

    # rule 1: if there is colon or hypen then remove space on either side of it
    #content = content.gsub(/\s*[:–-]\s*/, ":")
    #rule 1: remove different symbol
    content = content.gsub(/\s\–\s/,"-")
    #rule 2:remove brackets
    content = content.gsub(/\(|\)/, "")
    #rule 3: remove space before colon
    content = content.gsub(/\s\:/,":")
    #rule 4: remove space after colon
    content = content.gsub(/\:\s/,":""")
    #rule 5: put space after book name
    content = content.gsub(/(#{$books})(\d{1,2})/, '\1 \2')
    #rule 6: replace "," into "-"
    content = content.gsub(/\,/,"-")
    #rule 7: remove after "-"
    content = content.gsub(/\-\s/," ")
    #rule 8: remove space before "-"
    content = content.gsub(/\s\-/," ")
    #rule 9: remove ";" before space
    content = content.gsub(/\s\;/," ")
    #rule 10: replace ";" into ","
    content = content.gsub(/\;/,",")
    #rule 11: replace "I" into numeric
    content = content.gsub(/1(\s\w+\s\d+:)/, 'I\1')
    #rule 12: adding "," between verses of the same chapter 
     content = content.gsub(/(\d+)(\s\d+:)/, '\1, \2')
     #rule 13 : remove space between verse
    content = content.gsub(/(\d+\,)(\s+)/, '\1 ')
    #Luke 22:54-60Luke 22:31-34 
    content = content.gsub(/(w+ \d+\:\d+\-\d+)(w+ \d+\:\d+\-\d+)/ ,'\1, \2')
     # below rules for adding book name prefix place
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}-\d{1,2}), (\d{1,2}):(\d{1,2}-\d{1,2}), (\d{1,2}\:\d{1,2})/, '\1 \2:\3, \1 \4:\5, \1 \6') 
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}-\d{1,2}), (\d{1,2}):(\d{1,2}-\d{1,2})/, '\1 \2:\3, \1 \4:\5') 
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}), (\d{1,2}):(\d{1,2}-\d{1,2})/, '\1 \2:\3, \1 \4:\5')
     #Galatians 1:11-17 21-24 Galatians 1:11-17 21-24
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}-\d{1,2}) (\d{1,2}-\d{1,2})/, '\1 \2:\3 \1 \4')
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}), (\d{1,2}):(\d{1,2})/,'\1 \2:\3, \1 \4:\5')
     #1 Corinthians 12:1-11, 7:7, 2:6-7 Corinthians 12:1-11, 1 Corinthians 7:7, 1 Corinthians 2:6-7, 12:13-16
     content = content.gsub(/(\d \w+) (\d{1,2}):(\d{1,2}-\d{1,2}), (\d{1,2}):(\d{1,2}), (\d{1,2}):(\d{1,2}-\d{1,2}), (\d{1,2}):(\d{1,2}-\d{1,2})/, '\1 \2:\3, \1 \4:\5, \1 \6:\7, \1 \8:\9')
     #Acts 11:25-30, 12:25, 13:1-4, 15:36-39, 16:1-40, 18:23-28
     content = content.gsub(/(\w+) (\d+:\d+-\d+), (\d+\:\d+), (\d+:\d+-\d+), (\d+:\d+-\d+), (\d+:\d+-\d+), (\d+:\d+-\d+)/, '\1 \2, \1 \3, \1 \4, \1 \5, \1 \6, \1 \7')
     #Acts 13:50-52, 14:11
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}-\d{1,2}), (\d+\:\d+)/, '\1 \2:\3, \1 \4')
     #Acts 11:19-21, 22:20
    File.write("./regex/sanitized/#{fname}", content)
  end
end 
sanitize