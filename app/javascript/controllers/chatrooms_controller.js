import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chatroom"
export default class extends Controller {
  static targets = [
    'list',
    'chat',
    'messages',
  ]

  connect() {
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.messagesTarget, { childList: true })
  }

  disconnect() {
    this.observer.disconnect()
  }

  listTargetConnected(){
    this.updateReadStatus()
  }
  
  chatTargetConnected(){
    this.scrollToBottom()
    this.messagesTarget.classList.remove('opacity-0')
    this.updateReadStatus()
  }

  updateReadStatus(){
    const chatroomId = this.chatTarget.dataset.chatroomId
    const chatroomListItemEl = this.listTarget.querySelector(`#chatroom_list_item_${chatroomId}`)
    if (!chatroomListItemEl) return

    chatroomListItemEl.classList.remove('text-red-500')
    chatroomListItemEl.classList.add('text-blue-600')
  }

  scrollToBottom() {
    const messagesContainer = this.messagesTarget
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }
}
