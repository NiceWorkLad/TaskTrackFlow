import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.applyStoredTheme()
  }

  toggle() {
    const next = this.currentTheme() === "dark" ? "light" : "dark"
    this.setTheme(next)
  }

  currentTheme() {
    return document.documentElement.getAttribute("data-theme")
  }

  setTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme)
    localStorage.setItem("theme", theme)
  }

  applyStoredTheme() {
    const stored = localStorage.getItem("theme")
    if (stored) this.setTheme(stored)
  }
}
