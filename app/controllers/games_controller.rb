require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = 10.times.map {rand(97...122).chr.upcase}
    
  end

  def score
    grid = params[:letters].chars
    attempt = params[:word].upcase
    session[:current_score] ? '' : session[:current_score] = 0
    @result = check_offenses(attempt, grid)
  end

  private

  def hashify_letters_array(array)
    hash = Hash.new(0)
    array.each { |char| hash[char.downcase.to_sym] += 1 }
    hash
  end

  def attempt_in_grid?(attempt, grid)
    attempt.upcase.chars.all? { |char| grid.include?(char) }
  end
  
  def attempt_in_dictionary?(attempt)
    url = "https://dictionary.lewagon.com/#{attempt}"
    dictionary_serialized = URI.parse(url).read
    JSON.parse(dictionary_serialized)['found']
  end
  
  def valid_letter_count?(attempt, grid)
    attempt_count = hashify_letters_array(attempt.chars)
    grid_count = hashify_letters_array(grid)
    attempt_count.all? { |letter, count| count <= grid_count[letter] }
  end
  
  def check_offenses(attempt, grid)
    result = { attempt: attempt, grid: grid.join(', ')}
    validations = [
      [attempt_in_grid?(attempt, grid), :grid],
      [attempt_in_dictionary?(attempt), :dictionary],
      [valid_letter_count?(attempt, grid), :overused]
    ]
    failed_validation = validations.find { |validation| !validation[0] }
    if failed_validation
      result[:score] = 0
      result[:failure] = failed_validation[1]
    else
      result[:score] = result[:attempt].chars.count * 10
    end
    session[:current_score] += result[:score]
    result
  end

end
