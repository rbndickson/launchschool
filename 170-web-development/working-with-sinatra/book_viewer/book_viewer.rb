require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/:number" do
  chapter_number = params[:number]
  @contents = File.readlines("data/toc.txt")
  chapter_title = @contents[chapter_number.to_i - 1]
  @title = "Chapter #{@chapter_number}: #{chapter_title}"
  @chapter = File.read("data/chp#{chapter_number}.txt")

  erb :chapter
end
