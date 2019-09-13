#!/usr/bin/env ruby

class Animal
  attr_accessor :animal_name, :age, :weight, :max_weight, :min_weight, :analyzed_day, :additive_calory_counter, :subtractive_calory_counter
  ANALYZED_DAY = %w(siang malam)


  def initialize(args)
    @animal_name = args[:name]
    @age = args[:age] || 0
    @weight = args[:weight] || 0
    @max_weight = 100
    @min_weight = 10
    @additive_calory_counter = 3
    @subtractive_calory_counter = 1
  end

  def state
    { name: @animal_name, age: @age, weight: @weight }
  end

  def do_activity(day)
    return 'invalid analyzed day' unless  ANALYZED_DAY.include?(day.downcase())
    day = day.downcase()
    if day == 'siang'
      @weight += eat_or_slack
    elsif day == 'malam'
      @weight -= 1
    end
    @weight = snack_weighting
    state
  end

  private
  def eat_or_slack
    return (-1)*@subtractive_calory_counter if @weight >= @max_weight
    @additive_calory_counter
  end

  def snack_weighting
    return @min_weight if @weight < @min_weight
    @weight
  end
end

module DayAct
  DAY_STATE = %w(siang malam)

  def execute(animals, days)
    days.times do |count|
      puts "Hari ##{count}\n"
      animals.each do |animal|
        DAY_STATE.each do |day_state|
          animal.do_activity(day_state)
          puts print_state(animal.state, day_state)
        end
        animal.age += 1
      end
    end
  end

  def print_state(animal, state)
    name = animal[:name]
    age = animal[:age]
    weight = animal[:weight]
    "Kondisi #{name} di #{state} hari --> usia: #{age} -- berat: #{weight}\n"
  end

  module_function :execute, :print_state
end

def get_input
  gets.chomp
end

#main
input = gets.chomp.split(' ').map(&:to_i)
total_animals = input[0]
total_days = input[1]
animal_groups = []
total_animals.times do
  input = gets.chomp.split(' ')
  name = input[0]
  age = input[1].to_i
  weight = input[2].to_i
  animal_groups << Animal.new({name: name, age: age, weight: weight})
end
DayAct.execute(animal_groups, total_days)
