require_relative './meals'
require_relative './ingredients'
require_relative './printer'
require 'tty-prompt'
require 'pp'

# List of saved meals
meal_array = []
# List of saved ingredients
ingredients_list = []
# Shopping History (extension)

#**EM Read from file and populate meal_array
# data = File.read('data.txt')
# pp data
# meal_array = eval(data)
# pp meal_array

# User Choice Flows
def user_select_create_new_meal(prompt)
    ingredients = []
    #Ask the meal name
    name = prompt.ask("What is the name of your new meal?")
    #Ask for the ingredients
        #2 options: display existing ingredients
        #- enter new ingredient
    #Ask for the preference out of the three options
    preference = prompt.select("What preference would you like to give this meal?", [:low.capitalize, :medium.capitalize, :high.capitalize])
    #Suitable mealtimes
    mealtimes_array = prompt.multi_select("Which meal-times is this meal appropriate for?", [:breakfast.capitalize, :lunch.capitalize, :dinner.capitalize])

    new_meal = Meal.new(name, ingredients, preference, mealtimes_array)
    puts new_meal
    return new_meal
end





#**EM create options menu !
prompt = TTY::Prompt.new
# input = prompt.select("Welcome to your Meal Assistant. What would you like to do today?", default: 'Display My Saved Meals')
input = prompt.select("Welcome to your Meal Assistant. What would you like to do today?", ["Display My Saved Meals", "Add New Meal", "Generate Weekly Plan", "Generate Shopping List", "Exit Meal Assistant"])
puts input.freeze


while true 
    if input == "Display My Saved Meals"
        pp meal_array
        print_my_saved_meals(meal_array)
    elsif input == "Add New Meal"
        meal_array << user_select_create_new_meal(prompt)
    elsif input == "Generate Weekly Plan"
        #user_select_generate_weekly_plan()
    elsif input == "Generate Shopping List"
        #user_select_generate_shoping_list()
    elsif input == "Exit Meal Assistant"
        break
    else
        #This case shouldn't be possible with tty prompt
        assert()
    end
    input = prompt.select("Woud you like to do something else?", ["Display My Saved Meals", "Add New Meal", "Generate Weekly Plan", "Generate Shopping List", "Exit Meal Assistant"])
end


#system 'clear'
pp meal_array
meal_arr_str = ""
meal_array.each do |meal|
   # meal_arr_str = meal_arr_str + meal.to_s
   meal_arr_str = meal_arr_str + "/n" + meal.to_hash
end

# File.write('data.txt', meal_arr_str)

# ##### Test ######
# #Create Ingredients
# yogurt = Ingredient.new("yogurt")
# almonds = Ingredient.new("almonds")
# banana = Ingredient.new("banana")

# chicken = Ingredient.new("chicken")
# wrap = Ingredient.new("wrap")
# avocado = Ingredient.new("avocado")

# beef_mince = Ingredient.new("beef mince")
# chopped_tomato = Ingredient.new("chopped tomato")
# kidney_beans = Ingredient.new("Kidney Beans")
# olive_oil = Ingredient.new("Olive Oil")
# butter = Ingredient.new("Butter")


# #Create Meals
# yogurt_breakfast = Meal.new("Yogurt and Almonds", [yogurt, almonds, banana], :high, [:breakfast, :lunch])
# wrap_lunch = Meal.new("Chicken Wrap", [chicken, wrap, avocado], :high, [:lunch])
# chilli_dinner = Meal.new("Chilli con Carne", [beef_mince, chopped_tomato, kidney_beans, olive_oil, butter], :medium, [:lunch, :dinner])

# # Test chilli dinner populated as expected
# puts chilli_dinner
system 'clear'
