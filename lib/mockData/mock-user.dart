import '../models/chat-user-model.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

List<ChatUsers> chatUsers = [
  ChatUsers(
    userId: uuid.v4(),
    name: "Jane Russel",
    messageText: "Awesome Setup",
    imageURL: "assets/images/userImage.jpg",
    time: "Now",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "Glady's Murphy",
    messageText: "That's Great",
    imageURL: "assets/images/userImage.jpg",
    time: "Yesterday",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "Jorge Henry",
    messageText: "Hey where are you?",
    imageURL: "assets/images/userImage.jpg",
    time: "31 Mar",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "Philip Fox",
    messageText: "Busy! Call me in 20 mins",
    imageURL: "assets/images/userImage.jpg",
    time: "28 Mar",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "Debra Hawkins",
    messageText: "Thankyou, It's awesome",
    imageURL: "assets/images/userImage.jpg",
    time: "23 Mar",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "Jacob Pena",
    messageText: "will update you in evening",
    imageURL: "assets/images/userImage.jpg",
    time: "17 Mar",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "Andrey Jones",
    messageText: "Can you please share the file?",
    imageURL: "assets/images/userImage.jpg",
    time: "24 Feb",
  ),
  ChatUsers(
    userId: uuid.v4(),
    name: "John Wick",
    messageText: "How are you?",
    imageURL: "assets/images/userImage.jpg",
    time: "18 Feb",
  ),
];

ChatUsers getChatUsersById(String id) {
  for (ChatUsers user in chatUsers) {
    if (user.userId == id) {
      return user;
    }
  }
  // Return null if no animal with the given id is found
  return chatUsers[0];
}