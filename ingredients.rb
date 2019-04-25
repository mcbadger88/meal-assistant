class IngredientManager
    @@count = 0
    attr_reader(:saved_ingredients)
    def initialize
        @@count = @@count + 1
        @saved_ingredients = []
    end

    def add_ingredient_to_manager(ingredient)
        @saved_ingredients << ingredient
    end

    def lookup_ingredient_object(name_string)
        @saved_ingredients.each do |object|
            if object.name == name_string
                return object
            end
        end
        return nil
    end

    def to_s
        pp @saved_ingredients
    end
end
    
    
class Ingredient 
    attr_reader(:name)
    def initialize(name)
        @name = name.strip
    end
    
    def to_s
        @name.capitalize.strip
    end
end