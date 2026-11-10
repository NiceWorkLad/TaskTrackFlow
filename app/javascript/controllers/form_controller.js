import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitOnEnter(event) {
    if (event.key !== "Enter" || event.shiftKey) return

    event.preventDefault()

    if (this.element.reportValidity()) {
      this.element.requestSubmit()
    }
  }

  focus(event) {
    const target = event.currentTarget.querySelector("textarea, input:not([type=hidden])")
    target?.focus()
  }
}