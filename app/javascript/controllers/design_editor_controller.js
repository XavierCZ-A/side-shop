import { Controller } from "@hotwired/stimulus"

const VIBE_TOKENS = {
  editorial: {
    fontHeading:       '"Playfair Display", Georgia, serif',
    fontBody:          '"DM Sans", system-ui, sans-serif',
    primary:           "#111111",
    primaryForeground: "#ffffff",
    bg:                "#fafaf7",
    fg:                "#111111",
    muted:             "#6b6b6b",
    surface:           "#f1efe9"
  },
  organic: {
    fontHeading:       '"Fraunces", Georgia, serif',
    fontBody:          '"Nunito", system-ui, sans-serif',
    primary:           "#3a5a40",
    primaryForeground: "#f6f3ec",
    bg:                "#f6f1e7",
    fg:                "#2c2a25",
    muted:             "#7a7468",
    surface:           "#ece4d2"
  },
  modern: {
    fontHeading:       '"Space Grotesk", system-ui, sans-serif',
    fontBody:          '"Inter", system-ui, sans-serif',
    primary:           "#2563eb",
    primaryForeground: "#ffffff",
    bg:                "#ffffff",
    fg:                "#0a0a0a",
    muted:             "#737373",
    surface:           "#f4f4f5"
  }
}

export default class extends Controller {
  static targets = [
    "preview",
    "radiusLabel",
    "vibeOption", "vibeCheck",
    "heroOption", "radiusOption", "aspectOption"
  ]
  static values = { updateUrl: String, csrf: String }

  update(event) {
    const input = event.target
    const match = input.name.match(/store\[(\w+)\]/)
    if (!match) return

    const key   = match[1]
    const value = input.type === "checkbox" ? input.checked : input.value

    this.#applyToPreview(key, value)
    this.#highlightSelection(key, value)
    this.#persist(key, value)
  }

  #applyToPreview(key, value) {
    const root = this.previewTarget
    switch (key) {
      case "vibe":
        root.dataset.vibe = value
        this.#applyVibeTokens(value)
        break
      case "hero_layout":
        root.dataset.heroLayout = value
        break
      case "border_radius":
        root.style.setProperty("--sp-radius", `${value}px`)
        if (this.hasRadiusLabelTarget) {
          this.radiusLabelTarget.textContent = `radio actual · ${value}px`
        }
        break
      case "aspect_ratio":
        root.dataset.aspectRatio = value
        root.style.setProperty("--sp-aspect", value.replace(":", " / "))
        break
      case "grain_enabled":
        root.classList.toggle("storefront-grain", Boolean(value))
        break
    }
  }

  #applyVibeTokens(vibe) {
    const tokens = VIBE_TOKENS[vibe]
    if (!tokens) return
    const root = this.previewTarget
    root.style.setProperty("--sp-font-heading",            tokens.fontHeading)
    root.style.setProperty("--sp-font-body",               tokens.fontBody)
    root.style.setProperty("--sp-color-primary",           tokens.primary)
    root.style.setProperty("--sp-color-primary-foreground", tokens.primaryForeground)
    root.style.setProperty("--sp-color-bg",                tokens.bg)
    root.style.setProperty("--sp-color-fg",                tokens.fg)
    root.style.setProperty("--sp-color-muted",             tokens.muted)
    root.style.setProperty("--sp-color-surface",           tokens.surface)
    root.style.backgroundColor = "var(--sp-color-bg)"
    root.style.color           = "var(--sp-color-fg)"
    root.style.fontFamily      = "var(--sp-font-body)"
  }

  #highlightSelection(key, value) {
    const map = {
      vibe:          { targets: this.vibeOptionTargets,   attr: "vibeValue",   selectedClasses: ["border-2", "border-gray-800"], idleClasses: ["border", "border-gray-200", "hover:border-gray-300"] },
      hero_layout:   { targets: this.heroOptionTargets,   attr: "heroValue",   selectedClasses: ["border-2", "border-gray-800", "text-gray-900"], idleClasses: ["border", "border-gray-200", "text-gray-400", "hover:border-gray-300"] },
      border_radius: { targets: this.radiusOptionTargets, attr: "radiusValue", selectedClasses: ["border-2", "border-gray-800"], idleClasses: ["border", "border-gray-200", "hover:bg-gray-50"] },
      aspect_ratio:  { targets: this.aspectOptionTargets, attr: "aspectValue", selectedClasses: ["border-2", "border-gray-800"], idleClasses: ["border", "border-gray-200", "hover:bg-gray-50"] }
    }
    const cfg = map[key]
    if (!cfg) return

    cfg.targets.forEach(el => {
      const isSelected = String(el.dataset[cfg.attr]) === String(value)
      cfg.selectedClasses.forEach(c => el.classList.toggle(c, isSelected))
      cfg.idleClasses.forEach(c => el.classList.toggle(c, !isSelected))
    })

    if (key === "vibe" && this.hasVibeCheckTarget) {
      this.vibeCheckTargets.forEach(el => {
        el.classList.toggle("hidden", String(el.dataset.vibeValue) !== String(value))
      })
    }
  }

  #persist(key, value) {
    if (!this.hasUpdateUrlValue) return
    fetch(this.updateUrlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept":       "application/json",
        "X-CSRF-Token": this.csrfValue
      },
      credentials: "same-origin",
      body: JSON.stringify({ store: { [key]: value } })
    }).catch(err => console.error("design-editor persist failed", err))
  }
}
