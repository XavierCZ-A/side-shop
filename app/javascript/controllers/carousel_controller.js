import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "indicator"]
  static values = { index: { type: Number, default: 0 } }

  next() {
    this.indexValue = (this.indexValue + 1) % this.slideTargets.length
  }

  prev() {
    this.indexValue = (this.indexValue - 1 + this.slideTargets.length) % this.slideTargets.length
  }

  goTo(event) {
    this.indexValue = parseInt(event.currentTarget.dataset.index)
  }

  indexValueChanged() {
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("hidden", i !== this.indexValue)
    })

    this.indicatorTargets.forEach((dot, i) => {
      dot.classList.toggle("bg-white", i === this.indexValue)
      dot.classList.toggle("bg-white/50", i !== this.indexValue)
    })
  }
}
