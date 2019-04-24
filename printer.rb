require 'tty-table'

# Implement Printer module

def print_my_saved_meals(meal_array)

    meal_array.each do |my_meal|

        ingredient_rows_array = []
        ingredient_rows_array << ['Ingredients: ', my_meal.ingredients[0].name.capitalize]
        
        my_meal.ingredients.each_with_index do |meal_ingredient, index|
            if index != 0
                ingredient_rows_array << ['', meal_ingredient.name.capitalize]
            end
        end
        ingredient_rows_array << ['Preference: ', my_meal.preference.to_s]

        meal_type_arr = []
        my_meal.suitable_for.each do |key, value|
            if value
                meal_type_arr << key.capitalize.to_s
            else
            end
        end
        meal_type_str = meal_type_arr.join(', ')
        ingredient_rows_array << ['Meal Type/s: ', meal_type_str.capitalize]

        table = TTY::Table.new(['Meal Name: ', my_meal.name], ingredient_rows_array)
        puts table.render(:unicode, padding: [0,4,0,2])
    end
end

# # Implement Printer module
# def print_my_saved_meals(meal_array)
#     puts "Debug: In print_my_saved_meals"
#     puts meal_array
# end


# def print_weekly_plan(breakfast_array, lunch_array, dinner_array)
#     puts "Breakfast Array:"
#     pp breakfast_array
#     puts "Lunch Array:"
#     pp lunch_array
#     puts "Dinner Array:"
#     pp dinner_array
# end