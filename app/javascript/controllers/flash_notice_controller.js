import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["flash"];

  connect() {
    setTimeout(() => {
      this.close();
    }, 3000);
  }

  close() {
    if (this.hasFlashTarget) {
      this.flashTarget.classList.add(
        "transition",
        "duration-500",
        "opacity-0",
        "translate-x-100"
      );

      setTimeout(() => {
        this.element.remove();
      }, 500);
    } else {
      this.element.remove();
    }
  }
}
