

class Ingredient 
    attr_reader(:name)
    def initialize(name)
        @name = name
    end
end

class Meal 
    attr_reader(:name, :ingredients, :preference, :suitable_for)
    def initialize(name, ingredients, preference, breakfast, lunch, dinner)
        @name = name
        @ingredients = ingredients
        @preference = preference
        @suitable_for = { breakfast: breakfast,
            lunch: lunch,
            dinner: dinner
        }
    end
    def to_s 
        "#{@name}, #{@ingredients}, #{@preference}, #{@suitable_for}"
    end
end

#Create Inrgedients
yogurt = Ingredient.new("yogurt")
almonds = Ingredient.new("almonds")
banana = Ingredient.new("banana")

chicken = Ingredient.new("chicken")
wrap = Ingredient.new("wrap")
avocado = Ingredient.new("avocado")

beef_mince = Ingredient.new("beef mince")
chopped_tomato = Ingredient.new("chopped tomato")


#Create Meals
yogurt_breakfast = Meal.new("Yogurt and Almonds", [yogurt, almonds, banana], :high, true, false, false)

wrap_lunch = Meal.new("Chicken Wrap", [chicken, wrap, avocado], :high, false, true, false)

chilli_dinner = Meal.new("Chilli con Carne", [beef_mince, chopped_tomato, kidney_beans, olive_oil, butter])


meal_array = [yogurt_breakfast]

puts meal_array[0]

# Implement Printer module


def print_my_saved_meals(meal_array)

end