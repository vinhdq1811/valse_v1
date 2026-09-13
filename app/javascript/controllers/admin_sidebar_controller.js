import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay"]

  toggle() {
    this.sidebarTarget.classList.toggle("admin-sidebar--open")
    this.overlayTarget.classList.toggle("admin-overlay--visible")
  }

  close() {
    this.sidebarTarget.classList.remove("admin-sidebar--open")
    this.overlayTarget.classList.remove("admin-overlay--visible")
  }
}
