$books = "Genesis|Exodus|Leviticus|Numbers|Deuteronomy|Joshua|Judges|Ruth|Samuel|Kings|Chronicles|Ezra|Nehemiah|Esther|Job|Psalms|Proverbs|Ecclesiastes|Song of Solomon|Isaiah|Jeremiah|Lamentations|Ezekiel|Daniel|Hosea|Joel|Amos|Obadiah|Jonah|Micah|Nahum|Habakkuk|Zephaniah|Haggai|Zechariah|Malachi|Matthew|Mark|Luke|John|Acts|Romans|Corinthians|Galatians|Ephesians|Philippians|Colossians|Thessalonians|Timothy|Titus|Philemon|Hebrews|James|Peter|John|Jude|Revelation"
def sanitize
  files = Dir.entries("./regex/artifacts").select {|n| n.include?(".txt")}

  files.each do |fname|
    content = File.read("./regex/artifacts/#{fname}")

    # rule 1: if there is colon or hypen then remove space on either side of it
    #content = content.gsub(/\s*[:–-]\s*/, ":")
    content = content.gsub(/\s\–\s/,"-")
    content = content.gsub(/\(|\)/, "")
    content = content.gsub(/\s\:/,":")
    content = content.gsub(/\:\s/,":""")
    content = content.gsub(/(#{$books})(\d{1,2})/, '\1 \2')
    content = content.gsub(/\,/,"-")
    content = content.gsub(/\-\s/," ")
    content = content.gsub(/\s\-/," ")
    content = content.gsub(/\s\;/," ")
    content = content.gsub(/\;/,",")
    content = content.gsub(/\I\s/,"1"" ")
    
    File.write("./regex/sanitized/#{fname}", content)
  end
end 
sanitize