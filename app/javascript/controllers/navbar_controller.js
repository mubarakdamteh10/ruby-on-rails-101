import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["mobileMenu", "profileDropdown"]

  toggleMobileMenu() {
    this.mobileMenuTarget.classList.toggle("hidden")
  }

  toggleProfileDropdown() {
    this.profileDropdownTarget.classList.toggle("hidden")
  }

  // Close dropdowns when clicking outside
  disconnect() {
    // Optional: cleanup
  }
}
