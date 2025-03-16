import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "modal",
    "step",
    "stepContent",
    "nextButton",
    "prevButton",
    "closeButton",
    "form"
  ]
  
  connect() {
    // Initialiser la modal
    this.currentStep = 1
    this.totalSteps = this.stepTargets.length
    this.updateStepDisplay()
  }
  
  open() {
    this.modalTarget.classList.add("active")
    document.body.style.overflow = "hidden"
  }
  
  close() {
    this.modalTarget.classList.remove("active")
    document.body.style.overflow = ""
    
    // Réinitialiser la modal après fermeture
    setTimeout(() => {
      this.currentStep = 0
      this.updateStepDisplay()
    }, 300)
  }
  
  nextStep() {
    if (this.currentStep < this.totalSteps - 1) {
      this.currentStep++
      this.updateStepDisplay()
    }
  }
  
  prevStep() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.updateStepDisplay()
    }
  }
  
  goToStep(event) {
    const stepIndex = parseInt(event.currentTarget.dataset.step)
    if (!isNaN(stepIndex) && stepIndex >= 0 && stepIndex < this.totalSteps) {
      this.currentStep = stepIndex
      this.updateStepDisplay()
    }
  }
  
  updateStepDisplay() {
    // Mettre à jour les étapes
    this.stepTargets.forEach((step, index) => {
      if (index === this.currentStep) {
        step.classList.add("active")
        step.classList.remove("completed")
      } else if (index < this.currentStep) {
        step.classList.remove("active")
        step.classList.add("completed")
      } else {
        step.classList.remove("active")
        step.classList.remove("completed")
      }
    })
    
    // Mettre à jour le contenu des étapes
    this.stepContentTargets.forEach((content, index) => {
      if (index === this.currentStep) {
        content.classList.add("active")
      } else {
        content.classList.remove("active")
      }
    })
    
    // Mettre à jour les boutons
    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.disabled = this.currentStep === 0
    }
    
    if (this.hasNextButtonTarget) {
      if (this.currentStep === this.totalSteps - 1) {
        this.nextButtonTarget.textContent = "Enregistrer"
      } else {
        this.nextButtonTarget.textContent = "Suivant"
      }
    }
  }
  
  // Sélection d'options
  selectOption(event) {
    const container = event.currentTarget.closest(".data-sources-grid, .templates-grid")
    const cards = container.querySelectorAll(".data-source-card, .template-card")
    
    cards.forEach(card => {
      card.classList.remove("selected")
    })
    
    event.currentTarget.classList.add("selected")
  }
  
  // Sélection de couleur
  selectColor(event) {
    const colorOptions = event.currentTarget.closest(".color-options")
    const options = colorOptions.querySelectorAll(".color-option")
    
    options.forEach(option => {
      option.classList.remove("selected")
    })
    
    event.currentTarget.classList.add("selected")
    
    // Mettre à jour la valeur dans un champ caché si nécessaire
    const colorValue = event.currentTarget.dataset.color
    if (colorValue && this.hasFormTarget) {
      const hiddenInput = this.formTarget.querySelector('input[name="theme_color"]')
      if (hiddenInput) {
        hiddenInput.value = colorValue
      }
    }
  }
  
  // Soumission du formulaire
  submitForm(event) {
    if (this.currentStep === this.totalSteps - 1 && this.hasFormTarget) {
      // Si nous sommes à la dernière étape, soumettre le formulaire
      // event.preventDefault() // Décommenter si vous voulez gérer la soumission en AJAX
      
      // Exemple de soumission AJAX
      /*
      const formData = new FormData(this.formTarget)
      
      fetch(this.formTarget.action, {
        method: this.formTarget.method,
        body: formData,
        headers: {
          "Accept": "application/json"
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          this.showNotification("Paramètres enregistrés", "Vos paramètres ont été mis à jour avec succès.", "success")
          this.close()
        } else {
          this.showNotification("Erreur", "Une erreur est survenue lors de l'enregistrement des paramètres.", "error")
        }
      })
      .catch(error => {
        console.error("Erreur:", error)
        this.showNotification("Erreur", "Une erreur est survenue lors de l'enregistrement des paramètres.", "error")
      })
      */
    } else {
      // Sinon, passer à l'étape suivante
      this.nextStep()
    }
  }
  
  // Afficher une notification
  showNotification(title, message, type = "success") {
    const notification = document.createElement("div")
    notification.className = `notification ${type}`
    
    notification.innerHTML = `
      <i class="${type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle'}"></i>
      <div class="notification-content">
        <h4>${title}</h4>
        <p>${message}</p>
      </div>
      <button class="close-notification">&times;</button>
    `
    
    document.body.appendChild(notification)
    
    // Fermer la notification au clic
    notification.querySelector(".close-notification").addEventListener("click", () => {
      notification.classList.add("fade-out")
      setTimeout(() => {
        notification.remove()
      }, 300)
    })
    
    // Fermer automatiquement après 5 secondes
    setTimeout(() => {
      if (document.body.contains(notification)) {
        notification.classList.add("fade-out")
        setTimeout(() => {
          notification.remove()
        }, 300)
      }
    }, 5000)
  }
  
  // Empêcher la fermeture de la modal en cliquant à l'extérieur
  preventClose(event) {
    if (event.target === this.modalTarget) {
      event.stopPropagation()
    }
  }
} 