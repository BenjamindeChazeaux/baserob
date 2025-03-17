import { Controller } from "@hotwired/stimulus"

// Contrôleur Stimulus pour les flip cards
export default class extends Controller {
  connect() {
    console.log("Flip card controller connected");
  }
  
  flip() {
    this.element.classList.toggle("flip");
  }
}
