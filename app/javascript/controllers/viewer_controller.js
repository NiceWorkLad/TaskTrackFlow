import { Controller } from "@hotwired/stimulus"

// Shows an element only to signed-in viewers, and optionally only to the owner.
// Comments are broadcast to every viewer with the same HTML, so per-user
// controls (Reply, delete) are rendered hidden and revealed here.
//
//   <div hidden data-controller="viewer">                            signed-in only
//   <div hidden data-controller="viewer" data-viewer-owner-id-value="5">  owner only
export default class extends Controller {
  static values = { ownerId: String }

  connect() {
    const currentUserId = document.querySelector('meta[name="current-user-id"]')?.content

    const allowed = currentUserId &&
      (!this.hasOwnerIdValue || this.ownerIdValue === currentUserId)

    if (allowed) {
      this.element.hidden = false
    } else {
      this.element.remove()
    }
  }
}
