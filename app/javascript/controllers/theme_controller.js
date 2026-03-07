import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ["darkIcon", "lightIcon"]

  connect() {
    this.updateIcons()
  }

  toggle() {
    if (document.documentElement.classList.contains("dark")) {
      document.documentElement.classList.remove("dark")
      localStorage.setItem("color-theme", "light")
    } else {
      document.documentElement.classList.add("dark")
      localStorage.setItem("color-theme", "dark")
    }
    this.updateIcons()
  }

  updateIcons() {
    if (document.documentElement.classList.contains("dark")) {
      this.darkIconTarget.classList.add("hidden")
      this.lightIconTarget.classList.remove("hidden")
    } else {
      this.darkIconTarget.classList.remove("hidden")
      this.lightIconTarget.classList.add("hidden")
    }
  }
}
