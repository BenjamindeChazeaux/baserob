import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Form controller connected")
    this.adjustWidth()
    this.inputTarget.addEventListener('input', () => this.adjustWidth())
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

  adjustWidth() {
    const input = this.inputTarget
    const tempSpan = document.createElement('span')
    tempSpan.style.cssText = window.getComputedStyle(input).cssText
    tempSpan.style.position = 'absolute'
    tempSpan.style.visibility = 'hidden'
    tempSpan.style.whiteSpace = 'pre'
    tempSpan.textContent = input.value || input.placeholder
    document.body.appendChild(tempSpan)

    const minWidth = 200 // Largeur minimale
    const maxWidth = 600 // Largeur maximale
    const computedWidth = Math.min(Math.max(tempSpan.offsetWidth + 20, minWidth), maxWidth)

    input.style.width = `${computedWidth}px`
    document.body.removeChild(tempSpan)
  }
}
