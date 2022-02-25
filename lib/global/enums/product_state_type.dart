import 'dart:ui';

class ProductStateType {
  // enum State { writing, uploaded, chatting, making, done };
  static const String request = "request"; // 승인대기중
  static const String uploaded = "uploaded"; //작성완료
  static const String comparing = "comparing"; //비교중
  static const String chatting = "chatting"; //상담중
  static const String ordering = "ordering"; // * badge에는 상담중으로 표시
  static const String making = "making"; //제조중 (공장측에서 발주 확인 버튼 클릭시)
  static const String done = "done"; //채팅창 상단 발주 버튼 눌러서 완료 했을때
  static const String rated = "rated"; // 후기 작성 완료

  // chaging be in a separate state so that product state is maintained after changes
  // static String changing = "changing";

  static Map<String, String> productStateMap = {
    "request": "승인요청",
    "uploaded": "작성완료",
    "comparing": "비교중",
    "chatting": "상담중",
    "ordering": "발주중",
    "making": "제작중",
    "done": "제작완료",
    "rated": "후기작성",
  };

  static String text(state) {
    return productStateMap[state] ?? "미작성";
  }

  static Color colorForState(state) {
    Map<String, int> map = {
      "request": 0xffC6C6C8,
      "uploaded": 0xffC6C6C8,
      "comparing": 0xff00CC52,
      "chatting": 0xff003fa3,
      "ordering": 0xff003fa3,
      "making": 0xff0058CF,
      "done": 0xff002E67,
      "rated": 0xff002E67,
    };
    int color = map[state] ?? 0xFFc4c9d4;
    return Color(color);
  }
}
