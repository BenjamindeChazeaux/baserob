import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  connect() {
    this.cardTargets.forEach(card => {
      card.addEventListener('click', this.flip.bind(this))
    })
  }

  disconnect() {
    this.cardTargets.forEach(card => {
      card.removeEventListener('click', this.flip.bind(this))
    })
  }

  flip(event) {
    const card = event.currentTarget
    card.classList.toggle('flipped')
  }
}
