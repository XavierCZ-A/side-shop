import { Controller } from "@hotwired/stimulus"
import { animate } from "motion"

export default class extends Controller {
  static targets = ["menu", "hamburger", "close"]

  connect() {
    this._menuOpen = false
  }

  toggle() {
    this._menuOpen ? this.#closeMenu() : this.#openMenu()
  }

  close() {
    if (this._menuOpen) this.#closeMenu()
  }

  #openMenu() {
    this._menuOpen = true

    // Anima icono hamburguesa -> X
    animate(this.hamburgerTarget, { rotate: 90, scale: 0, opacity: 0 }, { duration: 0.15 }).finished.then(() => {
      this.hamburgerTarget.classList.add("hidden")
      this.closeTarget.classList.remove("hidden")
      animate(this.closeTarget, { rotate: [-90, 0], scale: [0, 1], opacity: [0, 1] }, { duration: 0.15 })
    })

    // Anima menú
    this.menuTarget.classList.remove("hidden")
    animate(this.menuTarget, { opacity: [0, 1], y: [-6, 0] }, { duration: 0.18, easing: [0.25, 0.1, 0.25, 1] })
  }

  #closeMenu() {
    this._menuOpen = false

    animate(this.closeTarget, { rotate: 90, scale: 0, opacity: 0 }, { duration: 0.15 }).finished.then(() => {
      this.closeTarget.classList.add("hidden")
      this.hamburgerTarget.classList.remove("hidden")
      animate(this.hamburgerTarget, { rotate: [-90, 0], scale: [0, 1], opacity: [0, 1] }, { duration: 0.15 })
    })

    animate(this.menuTarget, { opacity: [1, 0], y: [0, -6] }, { duration: 0.15 }).finished.then(() => {
      this.menuTarget.classList.add("hidden")
    })
  }
}