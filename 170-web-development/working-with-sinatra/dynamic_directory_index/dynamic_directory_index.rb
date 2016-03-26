require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @public_files = Dir.entries("public").sort
  @public_files = @public_files.reverse if params[:order] == 'reverse'
  erb :home
end
