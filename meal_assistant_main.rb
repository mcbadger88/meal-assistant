require_relative './meals'
require_relative './ingredients'
require_relative './printer'
require_relative './shopping_list'
require 'tty-prompt'
require 'pp'

# 
# Utils
#
def populate_persistent_databases(meal_manager, ingredients_manager)
    # Read from file and populate meal_array
    data = File.read('data.txt')
    meal_array = eval(data)
    # pp meal_array

    if meal_array == nil
        return
    end

    # Populate databases
    meal_array.each do |meal_hash|
        # Read and create ingredients as necessary
        ingredients_array = []
        meal_hash[:ingredients].each do |ingredient|
            ingredient_object = ingredients_manager.lookup_ingredient_object(ingredient)
            if ingredient_object == nil
                ingredient_object = Ingredient.new(ingredient)
                ingredients_manager.add_ingredient_to_manager(ingredient_object)
            end
            ingredients_array << ingredient_object
        end

        meal_object = Meal.new(meal_hash[:name], ingredients_array, meal_hash[:preference], meal_hash[:suitable_for])
        meal_manager.add_meal_to_manager(meal_object)
    end

end

def save_databases(meal_manager)
    meal_db_string = "["
    meal_manager.saved_meals.each do |meal|
        if meal_db_string != "["
            meal_db_string = meal_db_string + ", #{meal.to_hash_string.strip}"
        else
            meal_db_string = meal_db_string + "#{meal.to_hash_string.strip}"
        end
    end
    meal_db_string = meal_db_string + "]"

    File.write('data.txt', meal_db_string)
end

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
            if ingredient_manager.saved_ingredients == []
                puts "No Saved Ingredients"
            else
                user_ingredients = prompt.multi_select("") do |menu|
                    menu.enum '.'
                    ingredient_manager.saved_ingredients.each do |ingredient|
                        menu.choice ingredient, ingredient
                    end
                end
                # Add user ingredients to list for this meal recipie
                new_meal_ingredients.concat(user_ingredients)
            end
        elsif input == "Add New Ingredient"
            ingredient_name = prompt.ask("What is the name of the ingredient you wish to add?")
            # Create New Ingredient
            new_ingredient = Ingredient.new(ingredient_name.strip)
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
    new_meal = Meal.new(name, new_meal_ingredients, preference.downcase, mealtimes_array)
    meal_manager.add_meal_to_manager(new_meal)
end

def user_select_generate_weekly_plan(meal_manager)
    return meal_manager.generate_weekly_plan()
end

def user_select_generate_shopping_list(shopping_manager, ingredient_manager, weekly_meal_hash)
    shopping_manager.generate_new_shopping_list(weekly_meal_hash)
end

# 
# Initilisation
#
prompt = TTY::Prompt.new
meal_manager = MealManager.new()
ingredient_manager = IngredientManager.new()
shopping_manager = ShoppingManager.new()
populate_persistent_databases(meal_manager, ingredient_manager)


#
# Begin User Flow
#
input = prompt.select("Welcome to your Meal Assistant. What would you like to do today?", ["Display My Saved Meals", "Add New Meal", "Generate Weekly Plan", "Generate Shopping List", "Exit Meal Assistant"])
puts input.freeze

weekly_meal_hash = {}
while true 
    if input == "Display My Saved Meals"
        print_my_saved_meals(meal_manager.saved_meals)
    elsif input == "Add New Meal"
        user_select_create_new_meal(prompt, meal_manager, ingredient_manager)
    elsif input == "Generate Weekly Plan"
        weekly_meal_hash = user_select_generate_weekly_plan(meal_manager)
        print_weekly_plan(weekly_meal_hash[:breakfast_array], weekly_meal_hash[:lunch_array], weekly_meal_hash[:dinner_array])
    elsif input == "Generate Shopping List"
        if weekly_meal_hash == {}
            puts "
Cannot generate shopping list until Weekly Meal Plan has been created. Please generate Weekly Meal Plan or select a different option.
            "
        else
            user_select_generate_shopping_list(shopping_manager, ingredient_manager, weekly_meal_hash)
        end
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
save_databases(meal_manager)

