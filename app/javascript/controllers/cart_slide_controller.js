import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "backdrop", "container"]
  static classes = ["open"]

  connect() {
    console.log("CartSlideController connected")
    this.boundEscClose = this.closeOnEsc.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundEscClose)
    document.body.style.overflow = ""
  }

  open(event) {
    event?.preventDefault()
    this.containerTarget.classList.remove("hidden")

    // Forzar reflow para que la transición funcione
    void this.panelTarget.offsetWidth

    this.backdropTarget.classList.remove("opacity-0")
    this.backdropTarget.classList.add("opacity-100")

    this.panelTarget.classList.remove("translate-x-full")
    this.panelTarget.classList.add("translate-x-0")

    document.body.style.overflow = "hidden"
    document.addEventListener("keydown", this.boundEscClose)
  }

  close(event) {
    event?.preventDefault()

    this.backdropTarget.classList.remove("opacity-100")
    this.backdropTarget.classList.add("opacity-0")

    this.panelTarget.classList.remove("translate-x-0")
    this.panelTarget.classList.add("translate-x-full")

    document.body.style.overflow = ""
    document.removeEventListener("keydown", this.boundEscClose)

    // Esperar a que termine la animación para ocultar
    setTimeout(() => {
      this.containerTarget.classList.add("hidden")
    }, 300)
  }

  closeOnEsc(event) {
    if (event.key === "Escape") this.close()
  }

  // Cierra solo si se hace click sobre el backdrop, no sobre el panel
  closeOnBackdrop(event) {
    if (event.target === this.backdropTarget) this.close()
  }
}