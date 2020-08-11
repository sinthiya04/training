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
    content = content.gsub(/I(\s\w+\s\d+:)/, '1\1')
    #rule 12: adding "," between verses of the same chapter 
     content = content.gsub(/(\d+)(\s\d+:)/, '\1, \2')
    byebug
     content = content.gsub(/(\w+) (\d{1,2}):(\d{1,2}-\d{1,2}), (\d{1,2}):(\d{1,2}-\d{1,2})/, '\1 \2:\3, \1 \4:\5') 
    byebug
     
  
    File.write("./regex/sanitized/#{fname}", content)
  end
end 
sanitize