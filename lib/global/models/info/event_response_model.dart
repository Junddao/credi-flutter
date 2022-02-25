import 'dart:convert';

class EventResponse {
  String? result;
  String? message;
  List<EventResponseData>? data;
  EventResponse({
    this.result,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'result': result,
      'message': message,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory EventResponse.fromMap(Map<String, dynamic> map) {
    return EventResponse(
      result: map['result'],
      message: map['message'],
      data: List<EventResponseData>.from(
          map['data']?.map((x) => EventResponseData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventResponse.fromJson(String source) =>
      EventResponse.fromMap(json.decode(source));
}

class EventResponseData {
  int? eventId;
  String? createdAt;
  String? updatedAt;
  EventModel? event;
  EventResponseData({
    this.eventId,
    this.createdAt,
    this.updatedAt,
    this.event,
  });

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'event': event?.toMap(),
    };
  }

  factory EventResponseData.fromMap(Map<String, dynamic> map) {
    return EventResponseData(
      eventId: map['eventId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      event: EventModel.fromMap(map['event']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventResponseData.fromJson(String source) =>
      EventResponseData.fromMap(json.decode(source));
}

class EventModel {
  int? id;
  String? url;
  String? image;
  int? orderId;
  bool? isShow;
  EventModel({
    this.id,
    this.url,
    this.image,
    this.orderId,
    this.isShow,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'image': image,
      'orderId': orderId,
      'isShow': isShow,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      url: map['url'],
      image: map['image'],
      orderId: map['orderId'],
      isShow: map['isShow'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));
}
