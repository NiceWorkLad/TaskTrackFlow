import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Visibility controller loaded")
  }

  show(event) {
    this.setVisibility(event.params.targets, false)
  }

  hide(event) {
    this.setVisibility(event.params.targets, true)
  }

  toggle(event) {
    event.params.targets.split(",").forEach((id) => {
      const target = document.getElementById(id.trim())
      if (target) {
        target.hidden = !target.hidden
      }
    })
  }

  setVisibility(targets, hidden) {
    targets.split(",").forEach((id) => {
      const target = document.getElementById(id.trim())

      if (target) {
        target.hidden = hidden
      }
    })
  }
}