class SocketConstants {
  //Default events
  static const String connectEvent = "connect";
  static const String disconnectEvent = "disconnect";
  static const String connectTimeoutEvent = "connect_timeout";
  static const String onSocketError = "onSocketError";

  // WebRTC Signaling Events
  static const String webrtcOffer = "webrtc-offer";
  static const String webrtcAnswer = "webrtc-answer";
  static const String webrtcIceCandidate = "webrtc-ice-candidate";
  static const String webrtcCallRequest = "webrtc-call-request";
  static const String webrtcCallAccepted = "webrtc-call-accepted";
  static const String webrtcCallRejected = "webrtc-call-rejected";
  static const String webrtcCallEnded = "webrtc-call-ended";

  // Basic Socket Events
  static const String sendMessage = "sendMessage";
  static const String onMessageSend = "onMessageSend";
  static const String connectCall = "connectCall";
  static const String onCallRequest = "onCallRequest";
  static const String acceptCall = "acceptCall";
  static const String onAcceptCall = "onAcceptCall";
  static const String rejectCall = "rejectCall";
  static const String onRejectCall = "onRejectCall";
  static const String cancelCall = "cancelCall";
  static const String onCancelCall = "onCancelCall";
  static const String endCall = "endCall";
  static const String onEndCall = "onEndCall";
  static const String unseenMessagesCount = "unseenMessagesCount";
  static const String onUnseenMessagesCount = "onUnseenMessagesCount";
  static const String likeProfile = "likeProfile";
  static const String onlikeProfile = "onLikeProfile";
  static const String viewProfile = "viewProfile";
  static const String onViewProfile = "onViewProfile";
  static const String registerSelf = "registerSelf";
  static const String onRegisterSelf = "onRegisterSelf";
  static const String onBlockUser = "onBlockUser";
  static const String blockUser = "blockUser";
  static const String onUnBlockUser = "onUnBlockUser";
  static const String unBlockUser = "unBlockUser";
  static const String transferCredit = "transferCredit";
  static const String onTransferCredit = "onTransferCredit";
  static const String onPaymentAproved = "onPaymentAproved";
  static const String onAnounceEvent = "onAnounceEvent";
  static const String onRemoveFromOnline = "onRemoveFromOnline";
  static const String onAddToOnline = "onAddToOnline";
  static const String typing = "typing";
  static const String onTyping = "onTyping";
  static const String typingStoped = "typingStoped";
  static const String onTypingStoped = "onTypingStoped";
  static const String deleteMessage = "deleteMessage";
  static const String onMessageDelete = "onMessageDelete";
  static const String editMessage = "editMessage";
  static const String onMessageEdit = "onMessageEdit";
  static const String onMobileBackGround = "onMobileBackGround";
  static const String iamOnCall = "iamOnCall";
  static const String onOtherCall = "onOtherCall";
  static const String chatCleared = "chatCleared";
  static const String onChatCleared = "onChatCleared";
  static const String addToShortCut = "addToShortCut";
  static const String onAddToShortCut = "onAddToShortCut";
  static const String userOffline = "userOffline";
  static const String bookAppointment = "bookAppointment";
  static const String appointmentBooked = "onAppointmentBooked";
  static const String acceptAppointment = "acceptAppointment";
  static const String appointmentAccepted = "onAppointmentAccepted";
}
