require_relative './meals'
require_relative './ingredients'
require 'tty-prompt'

# Test Cases for meal manager
# Test Case Init
prompt = TTY::Prompt.new
meal_manager = MealManager.new()
ingredient_manager = IngredientManager.new()

# Case 1 Test meal adding functionality
beef_mince = Ingredient.new("Beef Mince")
ingredient_manager.add_ingredient_to_manager(beef_mince)
chopped_tomato = Ingredient.new("Chopped Tomato")
ingredient_manager.add_ingredient_to_manager(chopped_tomato)
kidney_beans = Ingredient.new("Kidney Beans")
ingredient_manager.add_ingredient_to_manager(kidney_beans)

chilli_con_carne = Meal.new("Chilli Con Carne", [beef_mince, chopped_tomato, kidney_beans], :high, [:breakfast, :lunch])
meal_manager.add_meal_to_manager(chilli_con_carne)
random_meal = Meal.new("Random Meal", [beef_mince, chopped_tomato, kidney_beans], :medium, [:breakfast, :lunch, :dinner])
meal_manager.add_meal_to_manager(random_meal)

#Create Ingredients
yogurt = Ingredient.new("yogurt")
almonds = Ingredient.new("almonds")
banana = Ingredient.new("banana")

chicken = Ingredient.new("chicken")
wrap = Ingredient.new("wrap")
avocado = Ingredient.new("avocado")

beef_mince = Ingredient.new("beef mince")
chopped_tomato = Ingredient.new("chopped tomato")
kidney_beans = Ingredient.new("Kidney Beans")
olive_oil = Ingredient.new("Olive Oil")
butter = Ingredient.new("Butter")


#Create Meals
yogurt_breakfast = Meal.new("Yogurt and Almonds", [yogurt, almonds, banana], :high, [:breakfast, :lunch])
wrap_lunch = Meal.new("Chicken Wrap", [chicken, wrap, avocado], :high, [:lunch])
chilli_dinner = Meal.new("Chilli con Carne", [beef_mince, chopped_tomato, kidney_beans, olive_oil, butter], :medium, [:lunch, :dinner])

# Case 1, test user_select_generate_weekly_plan 
# Generate a fake meal database
pp meal_manager.generate_weekly_plan()
