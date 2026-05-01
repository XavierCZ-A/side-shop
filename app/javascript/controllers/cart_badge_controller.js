import { Controller } from "@hotwired/stimulus"
import { animate } from "motion"

const STORAGE_KEY = "cart_badge_count"

export default class extends Controller {
  static targets = ["badge", "icon"]

  connect() {
    const currentCount = parseInt(this.badgeTarget.textContent.trim()) || 0
    const stored = parseInt(sessionStorage.getItem(STORAGE_KEY) ?? "-1")

    if (stored >= 0 && currentCount !== stored) {
      this.#pulse()
    }

    sessionStorage.setItem(STORAGE_KEY, currentCount)
  }

  #pulse() {
    animate(
      this.badgeTarget,
      { scale: [1, 1.7, 0.85, 1] },
      { duration: 0.45, easing: [0.36, 0.07, 0.19, 0.97] }
    )

    if (this.hasIconTarget) {
      animate(
        this.iconTarget,
        { rotate: [0, -12, 10, -6, 0] },
        { duration: 0.45, easing: "ease-in-out" }
      )
    }
  }
}
