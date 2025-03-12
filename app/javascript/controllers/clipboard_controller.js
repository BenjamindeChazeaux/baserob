import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["source", "button"]
  static values = {
    successMessage: { type: String, default: "Copied!" },
    errorMessage: { type: String, default: "Failed to copy!" },
    resetDelay: { type: Number, default: 2000 }
  }

  connect() {
    console.log("Clipboard controller connected")
  }

  copy(event) {
    event.preventDefault()
    
    // Trouver le contenu à copier
    const sourceElement = this.hasSourceTarget ? this.sourceTarget : document.querySelector('#scriptContentPanel pre')
    
    if (!sourceElement) {
      console.error("Source element not found")
      this.showMessage(this.errorMessageValue, "error")
      return
    }
    
    // Récupérer le texte à copier
    const textToCopy = sourceElement.textContent.trim()
    
    // Copier dans le presse-papier
    navigator.clipboard.writeText(textToCopy)
      .then(() => {
        console.log("Text copied successfully")
        this.showMessage(this.successMessageValue, "success")
      })
      .catch(error => {
        console.error("Failed to copy text:", error)
        this.showMessage(this.errorMessageValue, "error")
      })
  }
  
  showMessage(message, type) {
    // Si nous avons une cible de bouton, mettre à jour son texte
    if (this.hasButtonTarget) {
      const originalText = this.buttonTarget.innerHTML
      this.buttonTarget.innerHTML = message
      
      // Réinitialiser le texte après un délai
      setTimeout(() => {
        this.buttonTarget.innerHTML = originalText
      }, this.resetDelayValue)
    } else {
      // Sinon, utiliser la méthode de notification du contrôleur quick-start
      const quickStartController = this.application.getControllerForElementAndIdentifier(
        document.querySelector('[data-controller="quick-start"]'),
        "quick-start"
      )
      
      if (quickStartController && typeof quickStartController.showNotification === 'function') {
        const title = type === "success" ? "Success!" : "Error!"
        quickStartController.showNotification(type, title, message)
      } else {
        // Fallback: afficher une alerte
        alert(message)
      }
    }
  }
}
