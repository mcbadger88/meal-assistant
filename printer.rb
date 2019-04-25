require 'tty-table'

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

def print_weekly_plan(breakfast_array, lunch_array, dinner_array)
    
    breakfast_rows_array = []
    breakfast_rows_array << "Breakfast"
    if breakfast_array[0] == nil
        breakfast_rows_array << "No Saved Breakfast Meals"
    else
        breakfast_array.each do |my_breakfast|
            breakfast_rows_array << my_breakfast.name.split.map(&:capitalize).join(' ')
        end
    end

    lunch_rows_array = []
    lunch_rows_array << "Lunch"

    if lunch_array[0] == nil
        lunch_rows_array << "No Saved Lunch Meals"
    else
        lunch_array.each do |my_lunch|
            lunch_rows_array << my_lunch.name.split.map(&:capitalize).join(' ')
        end
    end

    dinner_rows_array = []
    dinner_rows_array << "Dinner"

    if dinner_array[0] == nil
        dinner_rows_array << "No Saved Dinner Meals"
    else
        dinner_array.each do |my_dinner|
            dinner_rows_array << my_dinner.name.split.map(&:capitalize).join(' ')
        end
    end

    array_of_arrays = [breakfast_rows_array, lunch_rows_array, dinner_rows_array]
    table = TTY::Table.new(['', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'], array_of_arrays)
    puts table.render(:unicode, padding:[1,1], alignments:[:center], multiline: true)
    return array_of_arrays
end