import { Controller } from "@hotwired/stimulus"

/**
 * Contrôleur Stimulus pour gérer la modal de démarrage rapide (QuickStart)
 * Ce contrôleur gère l'affichage de la modal, la navigation entre les étapes,
 * la soumission du formulaire et l'affichage des notifications.
 */
export default class extends Controller {
  // Définition des éléments HTML ciblés par le contrôleur
  static targets = [
    "modal",       // La modal principale
    "step",        // Les indicateurs d'étapes (cercles numérotés)
    "stepContent", // Le contenu de chaque étape
    "prevButton",  // Bouton "Précédent"
    "nextButton",  // Bouton "Suivant"
    "finishButton", // Bouton "Terminer"
    "scriptPanel"  // Panneau affichant le script
  ]
  
  /**
   * Méthode appelée automatiquement lorsque le contrôleur est connecté à l'élément HTML
   * Initialise les variables et l'état initial
   */
  connect() {
    console.log("Quick Start controller connected")
    console.log("Modal target found:", this.hasModalTarget)
    console.log("Step targets found:", this.stepTargets.length)
    console.log("Step content targets found:", this.stepContentTargets.length)
    console.log("Script panel target found:", this.hasScriptPanelTarget)
    this.currentStep = 1
    this.totalSteps = this.stepTargets.length
  }
  
  // ===== MÉTHODES DE GESTION DE LA MODAL =====
  
  /**
   * Ouvre la modal de démarrage rapide
   */
  openModal(event) {
    if (event) event.preventDefault()
    console.log("Opening modal method called")
    
    if (!this.hasModalTarget) {
      console.error("Modal target not found!")
      return
    }
    
    console.log("Modal target:", this.modalTarget)
    this.modalTarget.classList.add('active')
    document.body.style.overflow = 'hidden'
  }
  
  /**
   * Ferme la modal de démarrage rapide
   */
  closeModal(event) {
    if (event) event.preventDefault()
    console.log("Closing modal")
    this.modalTarget.classList.remove('active')
    document.body.style.overflow = ''
  }
  
  /**
   * Ferme la modal si l'utilisateur clique en dehors du contenu
   */
  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.closeModal()
    }
  }
  
  // ===== MÉTHODES DE NAVIGATION ENTRE LES ÉTAPES =====
  
  /**
   * Passe à l'étape suivante
   */
  nextStep(event) {
    event.preventDefault()
    
    if (this.currentStep < this.totalSteps) {
      this.goToStep(this.currentStep + 1)
    }
  }
  
  /**
   * Revient à l'étape précédente
   */
  prevStep(event) {
    event.preventDefault()
    
    if (this.currentStep > 1) {
      this.goToStep(this.currentStep - 1)
    }
  }
  
  /**
   * Change l'affichage pour montrer l'étape spécifiée
   * @param {number} stepNumber - Le numéro de l'étape à afficher
   */
  goToStep(stepNumber) {
    // Mettre à jour l'étape actuelle
    this.currentStep = stepNumber
    
    // Mettre à jour les indicateurs d'étapes (cercles numérotés)
    this.updateStepIndicators()
    
    // Mettre à jour le contenu affiché
    this.updateStepContent()
    
    // Mettre à jour l'état des boutons (précédent/suivant/terminer)
    this.updateNavigationButtons()
    
    // Masquer le panneau de script lors du changement d'étape
    if (this.hasScriptPanelTarget) {
      this.scriptPanelTarget.style.display = 'none'
    }
  }
  
  /**
   * Met à jour l'apparence des indicateurs d'étapes
   * (Méthode d'aide pour goToStep)
   */
  updateStepIndicators() {
    this.stepTargets.forEach((step, index) => {
      const stepNum = index + 1
      
      if (stepNum === this.currentStep) {
        // Étape actuelle
        step.classList.add('active')
        step.classList.remove('completed')
      } else if (stepNum < this.currentStep) {
        // Étapes précédentes (complétées)
        step.classList.remove('active')
        step.classList.add('completed')
      } else {
        // Étapes futures (non complétées)
        step.classList.remove('active')
        step.classList.remove('completed')
      }
    })
  }
  
  /**
   * Met à jour le contenu affiché selon l'étape actuelle
   * (Méthode d'aide pour goToStep)
   */
  updateStepContent() {
    this.stepContentTargets.forEach((content) => {
      // Afficher uniquement le contenu de l'étape actuelle
      if (parseInt(content.dataset.step) === this.currentStep) {
        content.classList.add('active')
      } else {
        content.classList.remove('active')
      }
    })
  }
  
  /**
   * Met à jour l'état des boutons de navigation
   * (Méthode d'aide pour goToStep)
   */
  updateNavigationButtons() {
    // Désactiver le bouton "Précédent" à la première étape
    this.prevButtonTarget.disabled = this.currentStep === 1
    
    // Afficher le bouton "Terminer" à la dernière étape, sinon afficher "Suivant"
    if (this.currentStep === this.totalSteps) {
      this.nextButtonTarget.style.display = 'none'
      this.finishButtonTarget.style.display = 'block'
    } else {
      this.nextButtonTarget.style.display = 'block'
      this.finishButtonTarget.style.display = 'none'
    }
  }
  
  /**
   * Action finale lorsque l'utilisateur termine la configuration
   */
  finishSetup(event) {
    event.preventDefault()
    
    // Fermer la modal
    this.closeModal()
    
    // Afficher une notification de succès
    this.showNotification('success', 'Dashboard Created!', 'Your new dashboard has been set up successfully.')
  }
  
  // ===== MÉTHODES DE GESTION DU SCRIPT =====
  
  /**
   * Affiche ou masque le panneau contenant le script
   */
  toggleScriptVisibility(event) {
    event.preventDefault()
    console.log("Toggling script panel visibility - SIMPLIFIED VERSION")
    
    // Trouver le panneau de script
    const scriptPanel = document.getElementById('scriptContentPanel')
    
    if (!scriptPanel) {
      console.error("Script panel not found!")
      return
    }
    
    // Basculer l'affichage du panneau
    const isHidden = scriptPanel.style.display === 'none' || scriptPanel.style.display === ''
    scriptPanel.style.display = isHidden ? 'block' : 'none'
    
    // Mettre à jour le texte du bouton
    const viewButton = document.getElementById('viewScriptButton')
    if (viewButton) {
      viewButton.innerHTML = isHidden 
        ? '<i class="fas fa-eye-slash"></i> Hide Script'
        : '<i class="fas fa-eye"></i> View Script'
    }
  }
  
  // ===== MÉTHODES DE SOUMISSION DU FORMULAIRE =====
  
  /**
   * Soumet le formulaire de configuration via AJAX
   */
  submitForm(event) {
    // Empêcher la soumission normale du formulaire
    event.preventDefault()
    
    // Récupérer les données du formulaire
    const form = event.target
    const formData = new FormData(form)
    
    // Envoyer les données au serveur
    this.sendFormData(form, formData)
  }
  
  /**
   * Envoie les données du formulaire au serveur via fetch API
   * (Méthode d'aide pour submitForm)
   */
  sendFormData(form, formData) {
    fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        return response.json()
      }
      throw new Error('Network response was not ok')
    })
    .then(data => this.handleFormResponse(data))
    .catch(error => {
      console.error('Error:', error)
      this.showNotification('error', 'Error', 'There was an error saving your configuration.')
    })
  }
  
  /**
   * Traite la réponse du serveur après soumission du formulaire
   * (Méthode d'aide pour sendFormData)
   */
  handleFormResponse(data) {
    if (data.success) {
      // Si la sauvegarde a réussi, passer à l'étape du script (étape 3)
      this.goToStep(3)
      this.showNotification('success', 'Configuration Saved', 'Your configuration has been saved successfully.')
    } else {
      // Afficher un message d'erreur
      this.showNotification('error', 'Error', data.message || 'There was an error saving your configuration.')
    }
  }
  
  // ===== MÉTHODES DE NOTIFICATION =====
  
  /**
   * Affiche une notification à l'utilisateur
   * @param {string} type - Le type de notification ('success' ou 'error')
   * @param {string} title - Le titre de la notification
   * @param {string} message - Le message de la notification
   */
  showNotification(type, title, message) {
    // Créer l'élément de notification
    const notification = document.createElement('div')
    notification.className = `notification ${type}`
    notification.innerHTML = `
      <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
      <div class="notification-content">
        <h4>${title}</h4>
        <p>${message}</p>
      </div>
      <button class="close-notification">&times;</button>
    `
    document.body.appendChild(notification)
    
    // Ajouter un écouteur pour fermer la notification
    notification.querySelector('.close-notification').addEventListener('click', () => {
      this.closeNotification(notification)
    })
    
    // Supprimer la notification après 5 secondes
    setTimeout(() => {
      this.closeNotification(notification)
    }, 5000)
  }
  
  /**
   * Ferme et supprime une notification
   * @param {HTMLElement} notification - L'élément de notification à fermer
   */
  closeNotification(notification) {
    notification.classList.add('fade-out')
    setTimeout(() => {
      notification.remove()
    }, 300)
  }
  
  // Handle clicks on selectable items
  toggleSelection(event) {
    const item = event.currentTarget
    const parent = item.parentElement
    
    // If it's a single-select container
    if (parent.classList.contains('single-select')) {
      parent.querySelectorAll('.selected').forEach(el => {
        el.classList.remove('selected')
      })
    }
    
    item.classList.toggle('selected')
  }
  
  // Copy script to clipboard
  copyScript(event) {
    event.preventDefault();
    
    const preElement = document.querySelector('#scriptContentPanel pre');
    
    if (!preElement) {
      return this.showNotification('error', 'Copy Failed', 'Could not find the script content to copy.');
    }
    
    const textToCopy = preElement.textContent.trim();
    
    navigator.clipboard.writeText(textToCopy)
      .then(() => this.showNotification('success', 'Script Copied!', 'The script has been copied to your clipboard.'))
      .catch(err => this.showNotification('error', 'Copy Failed', `Could not copy the script to clipboard. ${err.message}`));
  }
}
