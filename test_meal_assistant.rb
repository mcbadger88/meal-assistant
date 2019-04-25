# These tests require the contents of test file 'test_data.txt' to be copied in to 'data.txt' before running
# This is in order to populate the meal and ingredient databases
require_relative './meals'
require_relative './ingredients'
require 'tty-prompt'
require_relative './printer'

# **Test Plan**
# | test num     | test method name         | inputs                         | expected result          | actual result            |
# | ------------ | ------------             | ------------------------------ | -------------            | -------------            |
# | *1 *         | generate_weekly_plan     | meal database as per printout  | high preference > medium | high preference > medium |
# |    *         |                          | below                          | medium preference > low  | medium preference > low  |
# |
# | *2*          | lookup_ingredient_object | ingredients database as per    | created meal object has  | created meal object has  |
# |   *          | Meal.new                 | printout below, new meal name  | mealtime 'lunch' set to  | mealtime 'lunch' set to  |
# |   *          | add_meal_to_manager      |                                | true                     | true                     |
# |
# | *3*          | print_weekly_plan        | 3 empty arrays                 | Returned print array     | Returned print array     |
# |   *          |                          |                                | contains error message   | contains error message   |


# Below is a Print out of meals used for these tests for ease of reference
# ┌───────────────────┬────────────────────────┐
# │  Meal Name:       │  Yogurt and Almonds    │
# ├───────────────────┼────────────────────────┤
# │  Ingredients:     │  Yogurt                │
# │                   │  Almonds               │
# │                   │  Banana                │
# │  Preference:      │  high                  │
# │  Meal Type/s:     │  Breakfast             │
# └───────────────────┴────────────────────────┘
# ┌───────────────────┬──────────────────┐
# │  Meal Name:       │  Chicken Wrap    │
# ├───────────────────┼──────────────────┤
# │  Ingredients:     │  Chicken         │
# │                   │  Wrap            │
# │                   │  Cheese          │
# │                   │  Raw spinach     │
# │  Preference:      │  medium          │
# │  Meal Type/s:     │  Lunch           │
# └───────────────────┴──────────────────┘
# ┌───────────────────┬─────────────┐
# │  Meal Name:       │  Fajitas    │
# ├───────────────────┼─────────────┤
# │  Ingredients:     │  Chicken    │
# │                   │  Wrap       │
# │                   │  Cheese     │
# │                   │  Paprika    │
# │                   │  Oil        │
# │  Preference:      │  low        │
# │  Meal Type/s:     │  Dinner     │
# └───────────────────┴─────────────┘
# ┌───────────────────┬───────────────────┐
# │  Meal Name:       │  Lentil Soup      │
# ├───────────────────┼───────────────────┤
# │  Ingredients:     │  Oil              │
# │                   │  Chicken stock    │
# │                   │  Carrots          │
# │                   │  Lentils          │
# │                   │  Onion            │
# │  Preference:      │  medium           │
# │  Meal Type/s:     │  Lunch, dinner    │
# └───────────────────┴───────────────────┘
# ┌───────────────────┬────────────────────────┐
# │  Meal Name:       │  Salmon and Spinach    │
# ├───────────────────┼────────────────────────┤
# │  Ingredients:     │  Salmon                │
# │                   │  Oil                   │
# │                   │  Frozen spinach        │
# │                   │  Sunflower seeds       │
# │                   │  Salt                  │
# │                   │  Butter                │
# │  Preference:      │  low                   │
# │  Meal Type/s:     │  Lunch, dinner         │
# └───────────────────┴────────────────────────┘
# ┌───────────────────┬──────────────────────┐
# │  Meal Name:       │  Carrot cake         │
# ├───────────────────┼──────────────────────┤
# │  Ingredients:     │  Oil                 │
# │                   │  Carrots             │
# │                   │  Butter              │
# │                   │  Flour               │
# │                   │  Golden syrup        │
# │                   │  Bicq                │
# │                   │  Bicarbonate soda    │
# │                   │  Vanilla essence     │
# │                   │  Egg                 │
# │  Preference:      │  low                 │
# │  Meal Type/s:     │  Breakfast           │
# └───────────────────┴──────────────────────┘
# ┌───────────────────┬──────────────────────┐
# │  Meal Name:       │  Chilli              │
# ├───────────────────┼──────────────────────┤
# │  Ingredients:     │  Paprika             │
# │                   │  Oil                 │
# │                   │  Onion               │
# │                   │  Salt                │
# │                   │  Butter              │
# │                   │  Beef mince          │
# │                   │  Chopped tomatoes    │
# │                   │  Tomato paste        │
# │                   │  Garlic              │
# │                   │  Red kidney beans    │
# │                   │  Brown rice          │
# │                   │  Capsicum            │
# │  Preference:      │  high                │
# │  Meal Type/s:     │  Lunch, dinner       │
# └───────────────────┴──────────────────────┘

#
# Test Setup
#
# Copied from main file, needed to populate databases for test cases
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

prompt = TTY::Prompt.new
meal_manager = MealManager.new()
ingredient_manager = IngredientManager.new()
populate_persistent_databases(meal_manager, ingredient_manager)

# 
# Test Cases for meal manager
# 
# Case 1
def test_generate_weekly_plan_random_meal_weightings(meal_manager)
    # Generate loads, count the occurences of each meal 
    chilli_count = 0
    cake_count = 0
    yogurt_count = 0
    fajita_count = 0
    lentil_count = 0
    1000.times do  |i|
        weekly_meal_hash =  meal_manager.generate_weekly_plan()
        weekly_meal_hash[:breakfast_array].each do |meal|
            # pp meal
            if meal.name == "Chilli"
                chilli_count = chilli_count + 1
            end
            if meal.name == "Carrot cake"
                cake_count = cake_count + 1
            end
            if meal.name == "Yogurt and Almonds"
                yogurt_count = yogurt_count + 1
            end
            if meal.name == "Lentil Soup"
                lentil_count = lentil_count + 1
            end
        end

        weekly_meal_hash[:lunch_array].each do |meal|
            # pp meal
            if meal.name == "Chilli"
                chilli_count = chilli_count + 1
            end
            if meal.name == "Carrot cake"
                cake_count = cake_count + 1
            end
            if meal.name == "Yogurt and Almonds"
                yogurt_count = yogurt_count + 1
            end
            if meal.name == "Fajitas"
                fajita_count = fajita_count + 1
            end
            if meal.name == "Lentil Soup"
                lentil_count = lentil_count + 1
            end
        end

        weekly_meal_hash[:dinner_array].each do |meal|
            # pp meal
            if meal.name == "Chilli"
                chilli_count = chilli_count + 1
            end
            if meal.name == "Carrot cake"
                cake_count = cake_count + 1
            end
            if meal.name == "Yogurt and Almonds"
                yogurt_count = yogurt_count + 1
            end
            if meal.name == "Fajitas"
                fajita_count = fajita_count + 1
            end
            if meal.name == "Lentil Soup"
                lentil_count = lentil_count + 1
            end
        end
    end

    puts "   Chilli Count: #{chilli_count}, Cake Count: #{cake_count}, Yogurt Count #{yogurt_count}, Fajita Count: #{fajita_count}, lentil Count: #{lentil_count}"

    # Expect count of high priority meals to be larger than medium priority meals
    puts "Testing high preference meal occurs more frequently than medium preference meal:"
    if yogurt_count > cake_count
        puts "PASS"
    else
        puts "FAIL"
    end
    # Expect count of medium priority meals to be larger than low priority meals
    puts "Testing medium preference meal occurs more frequently than low preference meal:"
    if lentil_count > fajita_count
        puts "PASS"
    else
        puts "FAIL"
    end
end

# Case 2
def test_add_new_meal(ingredient_manager, meal_manager)
    wrap = ingredient_manager.lookup_ingredient_object("Wrap")
    salmon = ingredient_manager.lookup_ingredient_object("Salmon")
    capsicum = ingredient_manager.lookup_ingredient_object("Capsicum")
    
    meal = Meal.new("my wrap", [wrap, salmon, capsicum], :low, [:lunch])
    meal_manager.add_meal_to_manager(meal)

    # Expect Ingredient and preference to be present in meal manager
    puts "Testing create and add meal contains correct values:"
    pass = false
    meal_manager.saved_meals.each do |meal|
        if meal.name == "my wrap"
            # pp meal
            if meal.suitable_for[:lunch] == true
               pass = true
            end
        end
    end
    if pass
        puts "PASS"
    else
        puts "FAIL"
    end
end

# Case 3 - Negative Case
def test_empty_input_meal_array_print_weekly_plan
    # Verfiy what happens if you pass in no meals to print weekly plan
    result_array = print_weekly_plan([], [], [])
    # pp result_array

    # Expect graceful handling and return of error message
    puts "Testing print weekly plan handles empty array gracefully and prints error message:"
    if result_array[0][1] == "No Saved Breakfast Meals"
        puts "PASS"
    else
        puts "FAIL"
    end
end


puts "Test Case 1: test_generate_weekly_plan_random_meal_weightings"
test_generate_weekly_plan_random_meal_weightings(meal_manager)

puts "Test Case 2: test_add_new_meal"
test_add_new_meal(ingredient_manager, meal_manager)

puts "Test Case 3: test_empty_input_meal_array_print_weekly_plan"
test_empty_input_meal_array_print_weekly_plan()