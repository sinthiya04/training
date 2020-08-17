require 'prawn'

Prawn::Document.generate('lesson_one.pdf') do
  text 'what is inside the pdf?'
end