# Meals Module
# Handles creating, deleting and modifying meals in the meals database.
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
    def to_hash
        str = "
        { name: #{@name},
        ingrediente: #{@ingredients},
        preference: #{@preference},
        suitable_for: #{@suitable_for}
        }
        "
    end
end

