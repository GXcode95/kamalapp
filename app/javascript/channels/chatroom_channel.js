import consumer from "channels/consumer";

const chatroomElement = document.getElementById("messages");
const chatroomId = chatroomElement?.dataset.chatroomId;

if (chatroomId) {
  consumer.subscriptions.create({ channel: "ChatroomChannel", id: chatroomId }, {
    connected() {
      console.log(`Connected to ChatroomChannel for chatroom ID: ${chatroomId}`);
    },

    disconnected() {
      console.log(`Disconnected from ChatroomChannel for chatroom ID: ${chatroomId}`);
    },

    received(data) {
      console.log(`New data received for chatroom ID ${chatroomId}:`, data);
      // Insert the new message into the chat
      const messagesContainer = document.getElementById("messages");
      messagesContainer.insertAdjacentHTML("beforeend", data);
    }
  });
} else {
  console.warn("No chatroom ID found!");
}
