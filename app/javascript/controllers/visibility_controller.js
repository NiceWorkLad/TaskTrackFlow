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

  hideAfterSubmit(event) {
    if (event.detail.success) {
      event.target.reset()

      const target = document.getElementById(event.params.targets)

      if (target) {
        target.hidden = true
      }
    }
  }

  hideAfterReplySubmit(event) {
    if (event.detail.success) {
      event.target.reset()

      const formTarget = document.getElementById(event.params.targets)
      const repliesTarget = document.getElementById(event.params.replyTarget)

      if (formTarget) { 
        formTarget.hidden = true
      }

      if (repliesTarget) {
        repliesTarget.hidden = false
      }
    }
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