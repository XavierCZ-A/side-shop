import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 5000 },
  };

  connect() {
    this.timeoutId = setTimeout(() => {
      this.hideAndRemove();
    }, this.timeoutValue);
  }

  disconnect() {
    clearTimeout(this.timeoutId);
  }

  hideAndRemove() {
    this.element.classList.add("opacity-0", "-translate-y-2");

    this.element.addEventListener(
      "transitionend",
      (event) => {
        this.element.remove();
      },
      { once: true }
    );
  }
}
