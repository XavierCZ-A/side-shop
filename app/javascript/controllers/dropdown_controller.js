// app/javascript/controllers/dropdown_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    const isHidden = this.menuTarget.classList.contains("opacity-0")
    isHidden ? this.open() : this.close()
  }

  open() {
    clearTimeout(this.leaveTimeout)
    const menu = this.menuTarget

    menu.classList.remove("hidden")
    requestAnimationFrame(() => {
      menu.classList.remove("opacity-0", "-translate-y-2", "pointer-events-none")
      menu.classList.add("opacity-100", "translate-y-0")
    })
  }

  close() {
    const menu = this.menuTarget

    menu.classList.remove("opacity-100", "translate-y-0")
    menu.classList.add("opacity-0", "-translate-y-2", "pointer-events-none")
    menu.addEventListener("transitionend", () => {
      menu.classList.add("hidden")
    }, { once: true })
  }

  // click afuera del dropdown
  clickOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  // hover: entra al wrapper (botón + menú)
  enter() {
    clearTimeout(this.leaveTimeout)
    this.open()
  }

  // hover: sale del wrapper, con delay para evitar parpadeo
  leave() {
    this.leaveTimeout = setTimeout(() => this.close(), 150)
  }
}