import { Controller } from "@hotwired/stimulus"
import { animate } from "motion"

export default class extends Controller {
  static targets = ["menu", "hamburger"]

  connect() {
    this._menuOpen = false
    this.scrollHandler = this.#handleScroll.bind(this)
    window.addEventListener("scroll", this.scrollHandler, { passive: true })
  }

  disconnect() {
    window.removeEventListener("scroll", this.scrollHandler)
  }

  toggle() {
    this._menuOpen ? this.#closeMenu() : this.#openMenu()
  }

  close() {
    if (this._menuOpen) this.#closeMenu()
  }

  #openMenu() {
    this._menuOpen = true
    this.menuTarget.classList.remove("hidden")
    animate(this.menuTarget, { opacity: [0, 1], y: [-6, 0] }, { duration: 0.18, easing: [0.25, 0.1, 0.25, 1] })
    this.hamburgerTarget.querySelector(".icon-open")?.classList.add("hidden")
    this.hamburgerTarget.querySelector(".icon-close")?.classList.remove("hidden")
  }

  #closeMenu() {
    this._menuOpen = false
    animate(this.menuTarget, { opacity: [1, 0], y: [0, -6] }, { duration: 0.15 }).finished.then(() => {
      this.menuTarget.classList.add("hidden")
    })
    this.hamburgerTarget.querySelector(".icon-open")?.classList.remove("hidden")
    this.hamburgerTarget.querySelector(".icon-close")?.classList.add("hidden")
  }

  #handleScroll() {
    this.element.classList.toggle("shadow-sm", window.scrollY > 10)
  }
}
