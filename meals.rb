# Meals Module
# Handles creating, deleting and modifying meals in the meals database.

class MealManager
    @@count = 0
    attr_reader(:saved_meals)
    def initialize
        @@count = @@count + 1
        @saved_meals= []
    end

    def add_meal_to_manager(meal)
        @saved_meals << meal
    end

    def generate_weekly_plan
        weighted_breakfast_array = []
        weighted_lunch_array = []
        weighted_dinner_array = []

        weighting_converter_hash = {
            high: 3,
            medium: 2,
            low: 1
        }
        weekly_meal_hash = {
            breakfast_array: [],
            lunch_array: [],
            dinner_array: []
        }
        # Construct weighted arrays for 'randomly' choosing 7 breakfast, lunches, and dinners
        @saved_meals.each do |meal|
            # puts "DEBUG: in saved meals loop"
            # pp meal
            if meal.suitable_for[:breakfast]
                # puts "DEBUG: suitable for breakfast"
                weighting_converter_hash[meal.preference].times do |i|
                    # puts "DEBUG: adding to breakfast array"
                    # puts weighting_converter_hash[meal.preference]
                    weighted_breakfast_array << meal
                end
            end
            if meal.suitable_for[:lunch]
                weighting_converter_hash[meal.preference].times do |i|
                    weighted_lunch_array << meal
                end 
            end
            if meal.suitable_for[:dinner]
                weighting_converter_hash[meal.preference].times do |i|
                    weighted_dinner_array << meal
                end
            end
        end

        # Choose 7 meals from each array and store in ouput
        7.times do |i|
            j = rand(weighted_breakfast_array.length)
            weekly_meal_hash[:breakfast_array] << weighted_breakfast_array[j]
            k = rand(weighted_lunch_array.length)
            weekly_meal_hash[:lunch_array] << weighted_lunch_array[k]
            l = rand(weighted_dinner_array.length)
            weekly_meal_hash[:dinner_array] << weighted_dinner_array[l]
        end

        return weekly_meal_hash
    end

    def to_s
        pp @saved_meals
    end
end

class Meal 
    attr_reader(:name, :ingredients, :preference, :suitable_for)
    def initialize(name, ingredients, preference, mealtimes_array)
        @name = name
        @ingredients = ingredients
        @preference = preference
        @suitable_for = { breakfast: false,
            lunch: false,
            dinner: false,
        }
        # Iterate suitable_for array and populate hash.
        mealtimes_array.length.times do |i|
            @suitable_for[mealtimes_array[i].downcase] = true
        end

    end
    def to_s 
        ingredients_str = ""
        @ingredients.length.times do |i|
            ingredients_str = ingredients_str + "#{@ingredients[i]} "
        end

        "
        Meal name: #{@name.capitalize}, 
        Ingredients: #{ingredients_str}, 
        Preference rating: #{@preference.capitalize}, 
        Suitable for #{@suitable_for} "
    end
    def to_hash_string
        ingredients_string_array = []
        @ingredients.each do |ingredient|
            ingredients_string_array.push(ingredient.name.strip)
        end

        mealtimes_string_array = []
        @suitable_for.each do |mealtime, value|
            if value == true 
                mealtimes_string_array.push(mealtime.to_sym)
            end
        end

        "{ name: \"#{@name.strip}\", ingredients: #{ingredients_string_array}, preference: \:#{@preference.downcase}, suitable_for: #{mealtimes_string_array} }"
    end
end

