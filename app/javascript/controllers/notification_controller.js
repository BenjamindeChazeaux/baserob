import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Ferme automatiquement la notification après 5 secondes
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.element.classList.add('fade-out')
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
