class TodoModel {
  String? id;
  String? title;
  String? description;
  bool? iscompleted;

  TodoModel({
    this.id,
    this.title,
    this.description,
    this.iscompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      iscompleted: json["is_completed"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "is_completed": iscompleted ?? false,
    };
  }
}
