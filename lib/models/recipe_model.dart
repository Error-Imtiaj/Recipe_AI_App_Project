class RecipeModel {
    String? title;
    String? ingredients;
    String? servings;
    String? instructions;

    RecipeModel({this.title, this.ingredients, this.servings, this.instructions}); 

    RecipeModel.fromJson(Map<dynamic, dynamic> json) {
        title = json['title'];
        ingredients = json['ingredients'];
        servings = json['servings'];
        instructions = json['instructions'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['title'] = title;
        data['ingredients'] = ingredients;
        data['servings'] = servings;
        data['instructions'] = instructions;
        return data;
    }
}