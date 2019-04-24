require_relative './meals'
require_relative './ingredients'
require_relative './printer'
require 'tty-prompt'
require 'pp'

# 
# User Choice Flows
#
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

def user_select_generate_weekly_plan(meal_manager)
    return meal_manager.generate_weekly_plan()
end


# 
# Initilisation
#
prompt = TTY::Prompt.new
meal_manager = MealManager.new()
ingredient_manager = IngredientManager.new()
# To Do: Read CSV and populate DBs

#
# Begin User Flow
#
input = prompt.select("Welcome to your Meal Assistant. What would you like to do today?", ["Display My Saved Meals", "Add New Meal", "Generate Weekly Plan", "Generate Shopping List", "Exit Meal Assistant"])
puts input.freeze


while true 
    if input == "Display My Saved Meals"
        print_my_saved_meals(meal_manager.saved_meals)
    elsif input == "Add New Meal"
        user_select_create_new_meal(prompt, meal_manager, ingredient_manager)
    elsif input == "Generate Weekly Plan"
        weekly_meal_hash = user_select_generate_weekly_plan(meal_manager)
        print_weekly_plan(weekly_meal_hash[:breakfast], weekly_meal_hash[:lunch], weekly_meal_hash[:dinner])
    elsif input == "Generate Shopping List"
        #user_select_generate_shoping_list()
    elsif input == "Exit Meal Assistant"
        break
    else
        #This case shouldn't be possible with tty prompt
        assert()
    end
    input = prompt.select("Would you like to do something else?", ["Display My Saved Meals", "Add New Meal", "Generate Weekly Plan", "Generate Shopping List", "Exit Meal Assistant"])
end

# 
# Shutdown
#
system 'clear'
# To Do: Write DBs to CSV file
