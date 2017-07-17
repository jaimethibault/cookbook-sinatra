class Recipe
  attr_reader :name, :description, :cooking_time, :mark_as_done

  def initialize(options = {})
    @name = options[:name]
    @description = options[:description]
    @cooking_time = options[:cooking_time]
    @mark_as_done = options[:mark_as_done]
  end

  def tick_as_done
    @mark_as_done = true
  end
end
