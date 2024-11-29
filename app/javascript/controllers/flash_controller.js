import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.classList.remove("opacity-0");
    // remove element after 10 seconds if data-notif-type is info or success
    if (
      this.element.dataset.notifType === "info" ||
      this.element.dataset.notifType === "success" ||
      this.element.dataset.notifType === "notice"
    ) {
      setTimeout(() => {
        this.close();
      }, 4000);
    }
  }

  close() {
    this.element.classList.add("opacity-0");
    // remove this.element after transition
    this.element.addEventListener("transitionend", () => {
      this.element.remove();
    });
  }
}
