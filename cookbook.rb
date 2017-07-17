require 'csv'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    CSV.foreach(@csv_file_path) do |row|
      options_hash = {name: row[0], description: row[1], cooking_time: row[2], mark_as_done: row[3] == 'true'}
      recipe_instance = Recipe.new(options_hash)
      @recipes << recipe_instance
    end
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    store_in_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    store_in_csv
  end

  def find(index)
    @recipes[index]
  end

  def store_done_status(index)
    options_hash = {name: @recipes[index].name, description: @recipes[index].description, cooking_time: @recipes[index].cooking_time, mark_as_done: true}
    @recipes[index] = Recipe.new(options_hash)
    p @recipes
    store_in_csv
  end

  private

  def store_in_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.mark_as_done]
      end
    end
  end
end
