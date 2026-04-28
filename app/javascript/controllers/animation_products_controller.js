import { Controller } from "@hotwired/stimulus"
import { animate, stagger } from "motion"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    requestAnimationFrame(() => this.animateCards())
  }

  animateCards() {
    const cards = this.cardTargets.length
      ? this.cardTargets
      : Array.from(this.element.querySelectorAll("[data-animation-products-target='card']"))

    if (cards.length === 0) return

    cards.forEach((card) => card.classList.remove("opacity-0"))

    try {
      
      animate(cards, {
        opacity: [0, 1],
        y: [40, 0],
        scale: [0.95, 1]
      },
      {
        duration: 0.4,
        delay: stagger(0.08),
        easing: [0.25, 0.1, 0.25, 1]
      }
    )} catch (_error) {}
  }

}