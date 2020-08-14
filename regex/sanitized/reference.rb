$books = "Genesis|Exodus|Leviticus|Numbers|Deuteronomy|Joshua|Judges|Ruth|Samuel|Kings|Chronicles|Ezra|Nehemiah|Esther|Job|Psalms|Proverbs|Ecclesiastes|Song of Solomon|Isaiah|Jeremiah|Lamentations|Ezekiel|Daniel|Hosea|Joel|Amos|Obadiah|Jonah|Micah|Nahum|Habakkuk|Zephaniah|Haggai|Zechariah|Malachi|Matthew|Mark|Luke|John|Acts|Romans|Corinthians|Galatians|Ephesians|Philippians|Colossians|Thessalonians|Timothy|Titus|Philemon|Hebrews|James|Peter|John|Jude|Revelation"
def reference
  files = Dir.entries("./regex/sanitized").select {|n| n.include?(".txt")}
   content = []
   
   files.each do |fname|
    sanitized_content = File.read("./regex/sanitized/#{fname}")
    
    re = /I{0,3}\s([a-zA-Z]+\s\d{1,3}:\d{1,3}-?\d{1,3}?)/

    sanitized_content.scan(re) do |match|
      content << match.compact.first
    
    end
   
   #File.write("./regex/sanitized/#{fname}", content)
   end
end 
reference



