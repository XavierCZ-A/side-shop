import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "icon", "successIcon"]

  copy(event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.value)
    
    this.iconTarget.classList.add("hidden")
    this.successIconTarget.classList.remove("hidden")
    
    setTimeout(() => {
      this.iconTarget.classList.remove("hidden")
      this.successIconTarget.classList.add("hidden")
    }, 2000)
  }
}
