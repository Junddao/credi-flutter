import 'dart:convert';

class ChatButtonTypeMessageModel {
  String? content;
  List<ButtonTypeModel>? buttons;
  ChatButtonTypeMessageModel({
    this.content,
    this.buttons,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'buttons': buttons?.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatButtonTypeMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatButtonTypeMessageModel(
      content: map['content'],
      buttons: List<ButtonTypeModel>.from(
          map['buttons']?.map((x) => ButtonTypeModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatButtonTypeMessageModel.fromJson(String source) =>
      ChatButtonTypeMessageModel.fromMap(json.decode(source));
}

class ButtonTypeModel {
  String? type;
  String? target;
  String? color;
  String? title;
  ButtonTypeModel({
    this.type,
    this.target,
    this.color,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'target': target,
      'color': color,
      'title': title,
    };
  }

  factory ButtonTypeModel.fromMap(Map<String, dynamic> map) {
    return ButtonTypeModel(
      type: map['type'] != null ? map['type'] : null,
      target: map['target'] != null ? map['target'] : null,
      color: map['color'] != null ? map['color'] : null,
      title: map['title'] != null ? map['title'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ButtonTypeModel.fromJson(String source) =>
      ButtonTypeModel.fromMap(json.decode(source));
}
