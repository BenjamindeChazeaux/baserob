import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Ferme automatiquement le message après 5 secondes
    setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  dismiss() {
    this.messageTarget.remove()
  }
}
