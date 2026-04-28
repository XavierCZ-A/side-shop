// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    const menu = this.menuTarget
    const isHidden = menu.classList.contains("opacity-0")

    if (isHidden) {
      menu.classList.remove("hidden")
      requestAnimationFrame(() => {
        menu.classList.remove("opacity-0", "-translate-y-2", "pointer-events-none")
        menu.classList.add("opacity-100", "translate-y-0")
      })
    } else {
      menu.classList.remove("opacity-100", "translate-y-0")
      menu.classList.add("opacity-0", "-translate-y-2", "pointer-events-none")
      menu.addEventListener("transitionend", () => {
        menu.classList.add("hidden")
      }, { once: true })
    }
  }

  // Cerrar al hacer click fuera
  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden", "opacity-0", "-translate-y-2")
    }
  }
}