import { Controller } from "@hotwired/stimulus"

// Contrôleur Stimulus pour les flip cards
export default class extends Controller {
  connect() {
    console.log("Flip card controller connected");
    
    // On supprime le comportement par défaut (clic sur la carte entière)
    this.element.removeAttribute("data-action");
  }
  
  flip(event) {
    // Empêche la propagation si l'élément parent a aussi un data-action
    event.stopPropagation();
    
    this.element.classList.toggle("flip");
  }
}
