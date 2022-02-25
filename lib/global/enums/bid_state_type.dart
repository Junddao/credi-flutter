import 'dart:ui';

class BidStateType {
  // enum State { writing, uploaded, chatting, making, done };
  static const String sent = "sent"; //작성완료
  static const String chatting = "chatting"; //비교중
  static const String making = "making"; //제조중 (공장측에서 발주 확인 버튼 클릭시)
  static const String done = "done"; //채팅창 상단 발주 버튼 눌러서 완료 했을때
  static const String rated = "rated"; // 후기 작성 완료

  // chaging be in a separate state so that product state is maintained after changes
  // static String changing = "changing";

  static Map<String, String> bidStateMap = {
    "sent": "발송완료",
    "chatting": "상담중",
    "making": "제작중",
    "done": "제작완료",
    "rated": "후기확인",
  };

  // static String text(state) {
  //   return productStateMap[state] ?? "미작성";
  // }

  static Color colorForState(state) {
    Map<String, int> map = {
      "sent": 0xffC6C6C8,
      "chatting": 0xff003fa3,
      "making": 0xff0058CF,
      "done": 0xff002E67,
      "rated": 0xff002E67,
    };
    int color = map[state] ?? 0xFFc4c9d4;
    return Color(color);
  }
}
