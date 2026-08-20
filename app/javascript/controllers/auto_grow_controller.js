import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.resize()
  }

  resize() {
    const scrollY = window.scrollY
    const scrollX = window.scrollX

    this.element.style.height = "auto"
    this.element.style.height = `${this.element.scrollHeight}px`

    window.scrollTo(scrollX, scrollY)
  }
}