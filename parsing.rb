require 'nokogiri'
require 'open-uri'
require_relative 'models/recipe'

class ScrapeLetsCookFrench
  attr_reader :keyword

  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{@keyword}"
    doc = Nokogiri::HTML(open(url), nil, 'utf-8')
    list_of_recipes = []
    doc.search('.m_contenu_resultat').each do |element|
      name = element.search('.m_titre_resultat').text.gsub("\n","").gsub("\r","").strip
      description = element.search('.m_detail_recette').text.gsub("\n","").gsub("\r","").gsub("Recipe - ","").strip
      regexp_index_result = element.search('.m_detail_time').text =~ /(\d+ min)/
      if regexp_index_result.nil?
        cooking_time = ""
      else
        match_data = element.search('.m_detail_time').text.strip.match(/(\d+ min)/)
        cooking_time = match_data[1]
      end
      options_hash = {name: name, description: description, cooking_time: cooking_time, mark_as_done: false}
      recipe = Recipe.new(options_hash)
      list_of_recipes << recipe
    end
    list_of_recipes
  end
end
