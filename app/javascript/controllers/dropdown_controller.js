import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["open"]

  toggle() {
    this.openTarget.classList.toggle("hidden")
  }

  hide(event) {
    if (this.element.contains(event.target) === false) {
      this.openTarget.classList.add("hidden")
    }
  }
}
