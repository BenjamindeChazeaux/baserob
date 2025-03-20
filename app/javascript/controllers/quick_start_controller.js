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

  static values = {
    isOpened: { type: Boolean, default: false }
  }
  
  /**
   * Initialisation du contrôleur
   */
  connect() {
    
    this.oldLogic()
    // Définir l'étape actuelle (commencer à l'étape 1)
    this.currentStep = 1
    // Nombre total d'étapes
    this.totalSteps = this.stepTargets.length
    // Vérifier si l'utilisateur a besoin de configurer une company
    console.log(this.isOpenedValue);
    
    // Initialiser les champs obligatoires par étape
    this.requiredFieldsByStep = {
      1: [], // Aucun champ obligatoire pour l'étape 1
      2: ['company_name', 'company_website'], // Champs obligatoires pour l'étape 2
      3: [], // Champs obligatoires pour l'étape 3
      4: []  // Aucun champ obligatoire pour l'étape 4
    }
    
    if (this.isOpenedValue) {
      console.log(this.modalTarget);
      
      this.openModal(new Event("lolz"))
    }
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
      this.showNotification('Please complete the company setup before continuing.')
      return
    }
    
    // Masquer la modal
    this.modalTarget.classList.remove('active')
    // Réactiver le défilement de la page
    document.body.style.overflow = ''
  }
  
  /**
   * Gère les clics à l'extérieur de la modal
   * Ferme la modal si le clic est en dehors du contenu
   */
  clickOutside(event) {
    // Si le clic est sur la modal mais pas sur son contenu
    if (event.target === this.modalTarget) {
      this.closeModal(event)
    }
  }
  
  // ===== NAVIGATION ENTRE LES ÉTAPES =====
  
  /**
   * Passe à l'étape suivante
   */
  nextStep(event) {
    event.preventDefault()
    
    // Vérifier si l'étape actuelle a des champs obligatoires
    if (this.validateCurrentStep()) {
      if (this.currentStep < this.totalSteps) {
        this.goToStep(this.currentStep + 1)
      }
    }
  }
  
  /**
   * Valide les champs obligatoires de l'étape actuelle
   * @returns {boolean} true si tous les champs obligatoires sont remplis, false sinon
   */
  validateCurrentStep() {
    // Supprimer les messages d'erreur existants
    this.clearAllErrorMessages()
    
    // Vérifier si l'étape actuelle a des champs obligatoires
    const requiredFields = this.requiredFieldsByStep[this.currentStep] || []
    if (requiredFields.length === 0) {
      return true // Pas de champs obligatoires pour cette étape
    }
    
    let isValid = true
    
    // Vérifier chaque champ obligatoire
    requiredFields.forEach(fieldId => {
      const field = document.getElementById(fieldId)
      if (field && (!field.value || field.value.trim() === '')) {
        this.showFieldError(field, 'This field is required')
        isValid = false
      }
    })
    
    // Si des champs sont invalides, afficher une notification
    if (!isValid) {
      this.showNotification('error', 'Validation Error', 'Please fill in all required fields before proceeding.')
    }
    
    return isValid
  }
  
  /**
   * Affiche un message d'erreur sous un champ
   * @param {HTMLElement} field - Le champ avec l'erreur
   * @param {string} message - Le message d'erreur à afficher
   */
  showFieldError(field, message) {
    // Créer l'élément de message d'erreur
    const errorElement = document.createElement('div')
    errorElement.className = 'field-error'
    errorElement.textContent = message
    errorElement.style.color = '#dc3545'
    errorElement.style.fontSize = '0.875rem'
    errorElement.style.marginTop = '0.25rem'
    
    // Ajouter une classe d'erreur au champ
    field.classList.add('is-invalid')
    field.style.borderColor = '#dc3545'
    
    // Insérer le message d'erreur après le champ
    const parentElement = field.parentElement
    parentElement.appendChild(errorElement)
    
    // Ajouter un écouteur pour supprimer le message d'erreur lorsque l'utilisateur modifie le champ
    field.addEventListener('input', () => {
      if (field.value && field.value.trim() !== '') {
        this.clearFieldError(field)
      }
    }, { once: true })
  }
  
  /**
   * Supprime le message d'erreur d'un champ
   * @param {HTMLElement} field - Le champ dont il faut supprimer l'erreur
   */
  clearFieldError(field) {
    // Supprimer la classe d'erreur du champ
    field.classList.remove('is-invalid')
    field.style.borderColor = ''
    
    // Supprimer le message d'erreur
    const parentElement = field.parentElement
    const errorElement = parentElement.querySelector('.field-error')
    if (errorElement) {
      errorElement.remove()
    }
  }
  
  /**
   * Supprime tous les messages d'erreur
   */
  clearAllErrorMessages() {
    // Supprimer tous les messages d'erreur
    document.querySelectorAll('.field-error').forEach(error => {
      error.remove()
    })
    
    // Réinitialiser le style des champs
    document.querySelectorAll('.is-invalid').forEach(field => {
      field.classList.remove('is-invalid')
      field.style.borderColor = ''
    })
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
    // Supprimer les messages d'erreur existants
    this.clearAllErrorMessages()
    
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
   * Termine la configuration et ferme la modal
   */
  finishSetup(event) {
    event.preventDefault()
    
    // Fermer la modal
    this.modalTarget.classList.remove('active')
    // Réactiver le défilement de la page
    document.body.style.overflow = ''
    
    // Afficher un message de succès
    this.showNotification('success', 'Setup Complete', 'Your account has been successfully configured!')
    
    // Recharger la page pour mettre à jour les données
    window.location.reload()
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
        ? '<i class="fas fa-eye"></i> View Script'
        : '<i class="fas fa-eye-slash"></i> Hide Script'
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
   * Soumet le formulaire de configuration - Version simplifiée
   */
  submitForm(event) {
    // Empêcher le comportement par défaut du formulaire
    event.preventDefault()
    
    // Récupérer le formulaire
    const form = document.getElementById('quickStartForm')
    const formData = new FormData(form)
    
    // Récupérer le token CSRF
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    const options = {
      method: form.method,
      body: formData,
      headers: {
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      }
    }

    console.log(options);
    
    // Soumettre le formulaire avec fetch
    fetch(form.action, options)
    .then(response => response.json())
    .then((data) => {
      if (data.success) {
        // Si nous sommes sur la dernière étape, recharger la page
        if (this.currentStep === this.totalSteps) {
          // Afficher un message de succès
          this.showNotification('success', 'Setup Complete', 'Your account has been successfully configured!')
          
          // Mettre à jour l'état
          this.needsCompanySetup = false
          
          // Fermer la modal
          this.modalTarget.classList.remove('active')
          document.body.style.overflow = '';
          
          // Recharger la page après un court délai
          setTimeout(() => {
            window.location.reload();
          }, 500);
        } else {
          // Sinon, passer à l'étape suivante
          this.goToStep(3)
          
          // Afficher un message de succès
          this.showNotification('success', 'Configuration saved successfully!')
          
          // Mettre à jour l'état
          this.needsCompanySetup = false
        }
      } else {
        // Afficher un message d'erreur
        this.showNotification('error', 'Error', data.message || 'Problem saving configuration')
        form.innerHTML = data.formHTML
      }
    })
    .catch((error) => {
      // En cas d'erreur
      this.showNotification('error', 'Error', 'An error occurred while saving the configuration')
      console.error(error)
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


  oldLogic() {
    document.addEventListener('DOMContentLoaded', function() {
      
      // Get the button and modal
      const openButton = document.getElementById('openModalButton');
      const modal = document.getElementById('quickStartModal');
      
      if (openButton && modal) {
      
      // Add click event listener to the button
      openButton.addEventListener('click', function(e) {
          e.preventDefault();
          modal.classList.add('active');
          document.body.style.overflow = 'hidden';
      });
      
      // Add click event listener to close button
      const closeButton = modal.querySelector('.close-modal');
      if (closeButton) {
          closeButton.addEventListener('click', function() {
          modal.classList.remove('active');
          document.body.style.overflow = '';
          });
      }
      
      // Close modal when clicking outside
      modal.addEventListener('click', function(e) {
          if (e.target === modal) {
          modal.classList.remove('active');
          document.body.style.overflow = '';
          }
      });
      
      // Setup stepper functionality
      let currentStep = 1;
      const totalSteps = modal.querySelectorAll('.step').length;
      const prevButton = document.getElementById('prevStep');
      const nextButton = document.getElementById('nextStep');
      const finishButton = document.getElementById('finishSetup');
      
      // Function to go to a specific step
      function goToStep(stepNumber) {
          currentStep = stepNumber;
          
          // Update step indicators
          modal.querySelectorAll('.step').forEach((step, index) => {
          const stepNum = index + 1;
          
          if (stepNum === currentStep) {
              step.classList.add('active');
              step.classList.remove('completed');
          } else if (stepNum < currentStep) {
              step.classList.remove('active');
              step.classList.add('completed');
          } else {
              step.classList.remove('active');
              step.classList.remove('completed');
          }
          });
          
          // Update step content
          modal.querySelectorAll('.step-content').forEach((content) => {
          if (parseInt(content.dataset.step) === currentStep) {
              content.classList.add('active');
          } else {
              content.classList.remove('active');
          }
          });
          
          // Update buttons
          prevButton.disabled = currentStep === 1;
          
          if (currentStep === totalSteps) {
          nextButton.style.display = 'none';
          finishButton.style.display = 'block';
          } else {
          nextButton.style.display = 'block';
          finishButton.style.display = 'none';
          }
      }
      
      // Add click event listeners to next and previous buttons
      if (nextButton) {
          nextButton.addEventListener('click', function(e) {
          e.preventDefault();
          if (currentStep < totalSteps) {
              goToStep(currentStep + 1);
          }
          });
      }
      
      if (prevButton) {
          prevButton.addEventListener('click', function(e) {
          e.preventDefault();
          if (currentStep > 1) {
              goToStep(currentStep - 1);
          }
          });
      }
      
      if (finishButton) {
          finishButton.addEventListener('click', function(e) {
          e.preventDefault();
          modal.classList.remove('active');
          document.body.style.overflow = '';
          
          // Show success notification
          const notification = document.createElement('div');
          notification.className = 'notification success';
          notification.innerHTML = `
              <i class="fas fa-check-circle"></i>
              <div class="notification-content">
              <h4>Dashboard Created!</h4>
              <p>Your new dashboard has been set up successfully.</p>
              </div>
              <button class="close-notification">&times;</button>
          `;
          document.body.appendChild(notification);
          
          // Add click event listener to close notification
          notification.querySelector('.close-notification').addEventListener('click', function() {
              notification.classList.add('fade-out');
              setTimeout(() => {
              notification.remove();
              }, 300);
          });
          
          // Remove notification after 5 seconds
          setTimeout(() => {
              notification.classList.add('fade-out');
              setTimeout(() => {
              notification.remove();
              }, 300);
          }, 5000);
          });
      }
      }
  });
  document.addEventListener('DOMContentLoaded', function() {
      
      // Vérifier si le modal existe
      const modal = document.getElementById('quickStartModal');
      
      // Vérifier si le bouton d'ouverture existe
      const openButton = document.getElementById('openModalButton');
      
      // Vérifier si le bouton de test existe
      const testButton = document.getElementById('testOpenModalButton');
      
      // Vérifier si le panneau de script existe
      const scriptPanel = document.getElementById('scriptContentPanel');
      
      // Ajouter un écouteur d'événement direct au bouton de test
      if (testButton) {
      testButton.addEventListener('click', function() {
          if (modal) {
          modal.classList.add('active');
          }
      });
      }
      
      // Ajouter un écouteur d'événement direct au bouton de visualisation du script
      const viewScriptButton = document.getElementById('viewScriptButton');
      if (viewScriptButton) {
      viewScriptButton.addEventListener('click', function(e) {
          e.preventDefault();
          if (scriptPanel) {
          if (scriptPanel.style.display === 'none' || scriptPanel.style.display === '') {
              scriptPanel.style.display = 'block';
          } else {
              scriptPanel.style.display = 'none';
          }
          }
      });
      }

    })
  }
}
