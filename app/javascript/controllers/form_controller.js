import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Form controller connected")
  }

  submit(event) {
    event.preventDefault()

    // Si c'est un select, on soumet directement le formulaire
    if (event.target.tagName === "SELECT") {
      event.target.form.requestSubmit()
      return
    }

    // Pour le formulaire d'ajout de mot-clé
    const form = event.target.closest("form")
    const input = this.inputTarget

    if (!input.value.trim()) {
      return
    }

    form.requestSubmit()
  }

  success() {
    // Réinitialiser le formulaire après un ajout réussi
    this.inputTarget.value = ""
    this.inputTarget.focus()
  }
}
