import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "modal", "backdrop", "panel", "form", "input", "results", "clearButton"]
  static values = { debounce: { type: Number, default: 300 } }

  connect() {
    this.timeout = null
    this.handleEscape = this.handleEscape.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleEscape)
    clearTimeout(this.timeout)
  }

  open(event) {
    event?.stopPropagation()

    this.modalTarget.classList.remove("hidden")
    this.modalTarget.offsetHeight

    this.backdropTarget.classList.remove("opacity-0")
    this.backdropTarget.classList.add("opacity-100")

    this.panelTarget.classList.remove("-translate-y-3", "opacity-0")
    this.panelTarget.classList.add("translate-y-0", "opacity-100")

    this.modalTarget.classList.remove("pointer-events-none")

    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.handleEscape)

    this.inputTarget.focus()
  }

  close() {
    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")

    this.panelTarget.classList.remove("translate-y-0", "opacity-100")
    this.panelTarget.classList.add("-translate-y-3", "opacity-0")

    this.modalTarget.classList.add("pointer-events-none")

    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.handleEscape)

    setTimeout(() => {
      this.modalTarget.classList.add("hidden")
      this.inputTarget.value = ""
      this.clearButtonTarget.classList.add("hidden")
      this.clearResults()
    }, 200)
  }

  clear() {
    this.inputTarget.value = ""
    this.inputTarget.focus()
    this.clearButtonTarget.classList.add("hidden")
    this.clearResults()
  }

  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    this.clearButtonTarget.classList.toggle("hidden", query.length === 0)

    if (query.length === 0) {
      this.clearResults()
      return
    }

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, this.debounceValue)
  }

  clearResults() {
    const frame = document.getElementById("search_results")
    if (frame) frame.innerHTML = ""
  }

  handleEscape(event) {
    if (event.key === "Escape") this.close()
  }
}