require_relative './meals'
require_relative './ingredients'
require_relative './printer'
require 'tty-prompt'
require 'pp'

# Shopping History (extension)

#**EM Read from file and populate meal_array
# data = File.read('data.txt')
# pp data
# meal_array = eval(data)
# pp meal_array

# Util

# User Choice Flows
def user_select_create_new_meal(prompt, meal_manager, ingredient_manager)
    # Collect User Input

    name = prompt.ask("What is the name of your new meal?")
    # Get the ingredients for the new meal from the user
    input = prompt.select("What ingredients do you need for #{name}?", ["Choose From Previous Ingredients", "Add New Ingredient"])
    new_meal_ingredients = []
    while true
        if input == "Choose From Previous Ingredients"
            user_ingredients = prompt.multi_select("") do |menu|
                menu.enum '.'
                ingredient_manager.saved_ingredients.each do |ingredient|
                    menu.choice ingredient, ingredient
                end
            end
            # Add user ingredients to list for this meal recipie
            new_meal_ingredients.concat(user_ingredients)
        elsif input == "Add New Ingredient"
            ingredient_name = prompt.ask("What is the name of the ingredient you wish to add?")
            # Create New Ingredient
            new_ingredient = Ingredient.new(ingredient_name)
            ingredient_manager.add_ingredient_to_manager(new_ingredient)
            # Add user ingredient to list for this meal recipie
            new_meal_ingredients << new_ingredient
        else 
            assert()
        end
        if prompt.yes?('Choose more ingredients?')
            input = prompt.select("", ["Choose From Previous Ingredients", "Add New Ingredient"])
        else 
            break
        end
    end 
    #Ask for the preference out of the three options
    preference = prompt.select("What preference would you like to give this meal?", [:low.capitalize, :medium.capitalize, :high.capitalize])
    mealtimes_array = prompt.multi_select("Which meal-times is this meal appropriate for?", [:breakfast.capitalize, :lunch.capitalize, :dinner.capitalize])

    # Create New Meal with user input
    new_meal = Meal.new(name, new_meal_ingredients, preference, mealtimes_array)
    meal_manager.add_meal_to_manager(new_meal)
end





#**EM create options menu !

# Initilisation
prompt = TTY::Prompt.new
meal_manager = MealManager.new()
ingredient_manager = IngredientManager.new()

# input = prompt.select("Welcome to your Meal Assistant. What would you like to do today?", default: 'Display My Saved Meals')
input = prompt.select("Welcome to your Meal Assistant. What would you like to do today?", ["Display My Saved Meals", "Add New Meal", "Generate Weekly Plan", "Generate Shopping List", "Exit Meal Assistant"])
puts input.freeze


while true 
    if input == "Display My Saved Meals"
        print_my_saved_meals(meal_manager.saved_meals)
    elsif input == "Add New Meal"
        user_select_create_new_meal(prompt, meal_manager, ingredient_manager)
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
