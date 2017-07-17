require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative 'cookbook'
require_relative 'models/recipe'
# require_relative 'parsing'

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  erb :index
end

get '/list' do
  @recipes = cookbook.all
  erb :list
end

get '/new' do
  erb :new
end

get '/create' do
  name = params[:name]
  description = params[:description]
  cooking_time = params[:cooking_time]
  options_hash = {name: name, description: description, cooking_time: cooking_time, mark_as_done: false}
  cookbook.add_recipe(Recipe.new(options_hash))
  redirect '/list'
end

get '/destroy' do
  @recipes = cookbook.all
  erb :destroy
end

get '/delete' do
  index = params[:index]
  cookbook.remove_recipe(index.to_i - 1)
  redirect '/list'
end

get '/import' do
  erb :import
end

get '/import2' do
  @keyword = params[:keyword]
  erb :import2
  # instance_of_scrape = ScrapeLetsCookFrench.new(keyword)
  # array_of_recipes = instance_of_scrape.call
  # index = @view.display_recipe_titles(keyword, array_of_recipes)
  # recipe_chosen = array_of_recipes[index.to_i - 1]
  # create_from_web(recipe_chosen)
end

get '/display_recipes_with_keyword' do
  keyword = params[:keyword]
  erb :display_recipes_with_keyword
end

