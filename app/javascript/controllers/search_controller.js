import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "statusField", "statusButton"]

  initialize() {
    this.submit = this.debounce(this.submit.bind(this), 300)
  }

  submit() {
    this.element.requestSubmit()
  }

  setStatus(event) {
    const button = event.currentTarget
    this.statusFieldTarget.value = button.dataset.value

    this.statusButtonTargets.forEach((b) => {
      b.classList.remove("btn-primary")
      b.classList.add("btn-outline")
    })
    button.classList.remove("btn-outline")
    button.classList.add("btn-primary")

    this.element.requestSubmit()
  }

  debounce(fn, delay) {
    let timeout
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => fn(...args), delay)
    }
  }
}
