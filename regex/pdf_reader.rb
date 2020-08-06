reader = PDF::Reader.new("/Users/amana/projects/training/training/regex/artifacts/Inter_ENGHB_L1.pdf")

content = reader.pages.map(&:text).join("\n")

File.write("./content.txt", content)

