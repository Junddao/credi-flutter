import 'dart:ui';

class OrderStateType {
  // enum State { writing, uploaded, chatting, making, done };
  static String pending = "pending";
  static String canceled = "canceled";
  static String denied = "denied";
  static String accepted = "accepted";
  static String done = "done";

  // chaging be in a separate state so that Order state is maintained after changes
  // static String changing = "changing";

  static String text(state, isFactory) {
    Map<String, String> map = isFactory
        ? {
            "canceled": "주문 취소",
            "pending": "작성 완료",
            "denied": "발주 거절",
            "accepted": "발주 승인",
            "done": "제작 완료",
          }
        : {
            "canceled": "주문 취소",
            "pending": "작성 완료",
            "denied": "발주 거절",
            "accepted": "발주 승인",
            "done": "제작 완료",
          };
    return map[state] ?? "미작성";
  }

  static Color colorForState(state) {
    Map<String, int> map = {
      "canceled": 0xff6e6e6e,
      "pending": 0xfffef10f,
      "denied": 0xffff2f23,
      "accepted": 0xff00a049,
      "done": 0xff000000,
    };
    int color = map[state] ?? 0xFFc4c9d4;
    return Color(color);
  }
}
