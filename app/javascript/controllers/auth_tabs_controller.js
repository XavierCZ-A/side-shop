import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="session-tabs"
export default class extends Controller {
  static targets = ["loginBtn", "registerBtn", "loginPanel", "registerPanel", "loginTitle", "loginSubtitle"]
  
  showLogin(event) {
    if (event) event.preventDefault()
    this.toggleState(true)
  }

  showRegister(event) {
    if (event) event.preventDefault()
    this.toggleState(false)
  }

  toggleState(isLogin) {
    const activeClasses = ["bg-white", "shadow-sm", "text-gray-900"]
    const inactiveClasses = ["text-gray-500", "hover:text-gray-700", "border-transparent"]

    if (isLogin) {
      this.loginBtnTarget.classList.add(...activeClasses)
      this.loginBtnTarget.classList.remove(...inactiveClasses)
      this.registerBtnTarget.classList.add(...inactiveClasses)
      this.registerBtnTarget.classList.remove(...activeClasses)

      this.loginPanelTarget.classList.remove("hidden")
      this.registerPanelTarget.classList.add("hidden")

      this.loginTitleTarget.textContent = "Bienvenido"
      this.loginSubtitleTarget.textContent = "Ingresa tus datos para acceder a tu tienda y seguir vendiendo."
    } else {
      this.registerBtnTarget.classList.add(...activeClasses)
      this.registerBtnTarget.classList.remove(...inactiveClasses)
      this.loginBtnTarget.classList.add(...inactiveClasses)
      this.loginBtnTarget.classList.remove(...activeClasses)

      this.registerPanelTarget.classList.remove("hidden")
      this.loginPanelTarget.classList.add("hidden")

      this.loginTitleTarget.textContent = "Crea tu Tienda Gratis"
      this.loginSubtitleTarget.textContent = "Únete a miles de vendedores. Solo necesitas 3 pasos para comenzar."
    }
  }
}
