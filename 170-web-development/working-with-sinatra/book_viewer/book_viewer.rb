require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  chapter_number = params[:number]
  chapter_title = @contents[chapter_number.to_i - 1]
  @title = "Chapter #{@chapter_number}: #{chapter_title}"
  @chapter = File.read("data/chp#{chapter_number}.txt")

  erb :chapter
end

helpers do
  def in_paragraphs(text)
    text = text.gsub("\n\n", "</p><p>")
    "<p>" + text + "</p>"
  end
end
