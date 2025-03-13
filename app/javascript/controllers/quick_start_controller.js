import { Controller } from "@hotwired/stimulus"

/**
 * Contrôleur pour la modal de démarrage rapide (QuickStart)
 * 
 * Ce contrôleur gère :
 * 1. L'ouverture et la fermeture de la modal
 * 2. La navigation entre les étapes
 * 3. La soumission du formulaire
 * 4. L'affichage des notifications
 */
export default class extends Controller {
  // Éléments HTML ciblés par le contrôleur
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
   * Initialisation du contrôleur
   */
  connect() {
    // Définir l'étape actuelle (commencer à l'étape 1)
    this.currentStep = 1
    // Nombre total d'étapes
    this.totalSteps = this.stepTargets.length
    // Vérifier si l'utilisateur a besoin de configurer une company
    this.needsCompanySetup = document.body.hasAttribute('data-needs-company-setup')
  }
  
  // ===== GESTION DE LA MODAL =====
  
  /**
   * Ouvre la modal
   */
  openModal(event) {
    if (event) event.preventDefault()
    
    // Vérifier que la modal existe
    if (!this.hasModalTarget) return
    
    // Afficher la modal
    this.modalTarget.classList.add('active')
    // Empêcher le défilement de la page
    document.body.style.overflow = 'hidden'
  }
  
  /**
   * Ferme la modal
   */
  closeModal(event) {
    if (event) event.preventDefault()
    
    // Si l'utilisateur n'a pas de company, empêcher la fermeture de la modal
    if (this.needsCompanySetup) {
      this.showNotification('warning', 'Setup Required', 'Please complete the company setup before continuing.')
      return
    }
    
    // Masquer la modal
    this.modalTarget.classList.remove('active')
    // Réactiver le défilement de la page
    document.body.style.overflow = ''
  }
  
  /**
   * Ferme la modal si l'utilisateur clique en dehors du contenu
   */
  clickOutside(event) {
    // Si l'utilisateur n'a pas de company, empêcher la fermeture de la modal
    if (this.needsCompanySetup) {
      this.showNotification('warning', 'Setup Required', 'Please complete the company setup before continuing.')
      return
    }
    
    // Si le clic est sur le fond de la modal (pas sur son contenu)
    if (event.target === this.modalTarget) {
      this.closeModal()
    }
  }
  
  // ===== NAVIGATION ENTRE LES ÉTAPES =====
  
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
   * Affiche l'étape spécifiée
   */
  goToStep(stepNumber) {
    // Mettre à jour l'étape actuelle
    this.currentStep = stepNumber
    
    // Mettre à jour les indicateurs d'étapes
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
        // Étapes futures
        step.classList.remove('active')
        step.classList.remove('completed')
      }
    })
    
    // Mettre à jour le contenu affiché
    this.stepContentTargets.forEach((content) => {
      if (parseInt(content.dataset.step) === this.currentStep) {
        content.classList.add('active')
      } else {
        content.classList.remove('active')
      }
    })
    
    // Mettre à jour les boutons
    this.prevButtonTarget.disabled = (this.currentStep === 1)
    
    if (this.currentStep === this.totalSteps) {
      // À la dernière étape, afficher le bouton "Terminer"
      this.nextButtonTarget.style.display = 'none'
      this.finishButtonTarget.style.display = 'block'
    } else {
      // Sinon, afficher le bouton "Suivant"
      this.nextButtonTarget.style.display = 'block'
      this.finishButtonTarget.style.display = 'none'
    }
    
    // Masquer le panneau de script lors du changement d'étape
    if (this.hasScriptPanelTarget) {
      this.scriptPanelTarget.style.display = 'none'
    }
  }
  
  /**
   * Action finale lorsque l'utilisateur termine la configuration
   */
  finishSetup(event) {
    event.preventDefault()
    
    // Mettre à jour l'état de configuration de la company
    this.needsCompanySetup = false
    
    // Fermer la modal
    this.closeModal()
    
    // Afficher une notification de succès
    this.showNotification('success', 'Dashboard Created!', 'Your new dashboard has been set up successfully.')
    
    // Recharger la page pour appliquer les changements
    setTimeout(() => {
      window.location.reload()
    }, 1500)
  }
  
  // ===== GESTION DU SCRIPT =====
  
  /**
   * Affiche ou masque le panneau contenant le script
   */
  toggleScriptVisibility(event) {
    event.preventDefault()
    
    // Trouver le panneau de script
    const scriptPanel = document.getElementById('scriptContentPanel')
    if (!scriptPanel) return
    
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
  
  /**
   * Copie le script dans le presse-papiers
   */
  copyScript(event) {
    event.preventDefault()
    
    // Trouver le contenu du script
    const preElement = document.querySelector('#scriptContentPanel pre')
    if (!preElement) {
      return this.showNotification('error', 'Copy Failed', 'Could not find the script content to copy.')
    }
    
    // Copier le texte
    const textToCopy = preElement.textContent.trim()
    navigator.clipboard.writeText(textToCopy)
      .then(() => this.showNotification('success', 'Script Copied!', 'The script has been copied to your clipboard.'))
      .catch(err => this.showNotification('error', 'Copy Failed', `Could not copy the script to clipboard. ${err.message || ''}`))
  }
  
  // ===== SOUMISSION DU FORMULAIRE =====
  
  /**
   * Soumet le formulaire de configuration
   */
  submitForm(event) {
    event.preventDefault()
    
    // Récupérer les données du formulaire
    const form = event.target
    const formData = new FormData(form)
    
    // Envoyer les données au serveur
    fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      credentials: 'same-origin'
    })
    .then(response => {
      if (!response.ok) throw new Error('Network response was not ok')
      return response.json()
    })
    .then(data => {
      if (data.success) {
        // Si la sauvegarde a réussi, passer à l'étape du script
        this.goToStep(3)
        this.showNotification('success', 'Configuration Saved', 'Your configuration has been saved successfully.')
        
        // Mettre à jour l'état de configuration de la company
        this.needsCompanySetup = false
      } else {
        // Afficher un message d'erreur
        this.showNotification('error', 'Error', data.message || 'There was an error saving your configuration.')
      }
    })
    .catch(error => {
      this.showNotification('error', 'Error', 'There was an error saving your configuration.')
    })
  }
  
  // ===== NOTIFICATIONS =====
  
  /**
   * Affiche une notification
   */
  showNotification(type, title, message) {
    // Créer l'élément de notification
    const notification = document.createElement('div')
    notification.className = `notification ${type}`
    notification.innerHTML = `
      <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'warning' ? 'exclamation-triangle' : 'exclamation-circle'}"></i>
      <div class="notification-content">
        <h4>${title}</h4>
        <p>${message}</p>
      </div>
      <button class="close-notification">&times;</button>
    `
    
    // Ajouter la notification à la page
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
}
