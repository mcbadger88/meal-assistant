require_relative './ingredients'

class ShoppingManager
    def initialize
        @shopping_list = []
        @corresponding_meals = {}
    end

    def add_ingredient_to_shopping_list(ingredient, meal_name)
        shopping_item = nil
        @shopping_list.each do |item|
            if item.name == ingredient.name
                shopping_item = item
            end
        end
        if shopping_item == nil
            shopping_item = ingredient
            @shopping_list << shopping_item
        end
        if @corresponding_meals[shopping_item.name.to_sym] == nil
            @corresponding_meals[shopping_item.name.to_sym] = [meal_name]
        else
            @corresponding_meals[shopping_item.name.to_sym] << meal_name
        end
    end

    def iterate_meals_and_add_ingredients_to_list(meal_array)
        meal_array.each do |meal|
            meal.ingredients.each do |ingredient|
                add_ingredient_to_shopping_list(ingredient, meal.name)
            end
        end
    end

    def generate_new_shopping_list(weekly_meal_hash)
        @shopping_list = []
        @corresponding_meals = {}
        iterate_meals_and_add_ingredients_to_list(weekly_meal_hash[:breakfast_array])
        iterate_meals_and_add_ingredients_to_list(weekly_meal_hash[:lunch_array])
        iterate_meals_and_add_ingredients_to_list(weekly_meal_hash[:dinner_array])

        # Print the List
        puts "
    Grocery List Based on Most recent Weekly Plan:
        "
        # pp @corresponding_meals
        @shopping_list.each do |item|
            # Construct meals string
            meals_str = ""
            prev_meal_name= ""
            count = 1
            meals = @corresponding_meals[item.name.to_sym].sort()
            # pp meals
            meals.each do |meal_name|
                if prev_meal_name == ""
                    # Do nothing for first item
                elsif meal_name == prev_meal_name
                    # If the name is the same as previous, just add 1 to the count
                    count = count + 1
                else 
                    # WHen name changes, print previous meal and count
                    meals_str = meals_str + "#{count} #{prev_meal_name}, "
                    count = 1
                end
                prev_meal_name = meal_name
            end
            # Once the end of the array is reached, print the last meal and count
            meals_str = meals_str + "#{count} #{prev_meal_name}, "

            puts "Buy enough #{item.name} for #{meals_str}"
        end
    end
end
