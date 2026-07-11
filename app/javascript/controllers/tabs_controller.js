// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "panel"]
  static values = { storageKey: String }

  connect() {
    const savedTab = localStorage.getItem(this.storageKeyValue)
    if (savedTab && this.hasTabTarget(savedTab)) {
      this.activate(savedTab)
    }
  }

  switch(event) {
    const id = event.currentTarget.dataset.tabId
    this.activate(id)
    localStorage.setItem(this.storageKeyValue, id)
  }

  activate(id) {
    this.triggerTargets.forEach(t => {
      const isActive = t.dataset.tabId === id
      t.setAttribute("aria-selected", isActive)
      t.classList.toggle("text-gray-900", isActive)
      t.classList.toggle("border-gray-900", isActive)
      t.classList.toggle("text-gray-500", !isActive)
      t.classList.toggle("border-transparent", !isActive)
    })

    this.panelTargets.forEach(p => p.classList.toggle("hidden", p.dataset.tabId !== id))
  }

  hasTabTarget(id) {
    return this.panelTargets.some(p => p.dataset.tabId === id)
  }
}