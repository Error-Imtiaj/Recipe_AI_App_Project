class RecipeModel {
  String? title;
  String? ingredients;
  String? servings;
  String? instructions;
  String? error;

  RecipeModel(
      {this.title,
      this.ingredients,
      this.servings,
      this.instructions,
      this.error});

  RecipeModel.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    ingredients = json['ingredients'];
    servings = json['servings'];
    instructions = json['instructions'];
    error = json['error'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['ingredients'] = ingredients;
    data['servings'] = servings;
    data['instructions'] = instructions;
    data['error'] = error;
    return data;
  }
}
