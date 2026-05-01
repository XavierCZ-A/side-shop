1
import { Controller } from "@hotwired/stimulus"
import { animate } from "motion"

export default class extends Controller {
  static targets = ["button"]

  animate(event) {
    this.#flyToCart()
    this.#setButtonLoading(event.target)
  }

  #flyToCart() {
    const cart = document.getElementById("cart_nav")
    if (!cart) return

    const source = this.hasButtonTarget ? this.buttonTarget : this.element
    const sourceRect = source.getBoundingClientRect()
    const cartRect = cart.getBoundingClientRect()

    const startX = sourceRect.left + sourceRect.width / 2
    const startY = sourceRect.top + sourceRect.height / 2
    const endX = cartRect.left + cartRect.width / 2
    const endY = cartRect.top + cartRect.height / 2

    const bubble = document.createElement("div")
    Object.assign(bubble.style, {
      position: "fixed",
      zIndex: "9999",
      width: "14px",
      height: "14px",
      borderRadius: "50%",
      background: "var(--color-primary, #000)",
      pointerEvents: "none",
      left: `${startX - 7}px`,
      top: `${startY - 7}px`,
    })
    document.body.appendChild(bubble)

    animate(
      bubble,
      {
        x: [0, (endX - startX) * 0.35, endX - startX],
        y: [0, (endY - startY) * 0.35 - 45, endY - startY],
        scale: [1, 1.15, 0.15],
        opacity: [1, 1, 0],
      },
      { duration: 0.6, easing: [0.36, 0.07, 0.19, 0.97] }
    ).finished.then(() => bubble.remove())
  }

  #setButtonLoading(form) {
    if (!this.hasButtonTarget) return
    const btn = this.buttonTarget
    const original = btn.innerHTML
    btn.disabled = true
    btn.innerHTML = "✓"

    const reset = () => {
      btn.disabled = false
      btn.innerHTML = original
    }

    form.addEventListener("turbo:submit-end", reset, { once: true })
    setTimeout(reset, 3000)
  }
}
