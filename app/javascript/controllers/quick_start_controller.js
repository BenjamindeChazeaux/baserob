import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "step", "stepContent", "prevButton", "nextButton", "finishButton", "scriptPanel"]
  
  connect() {
    console.log("Quick Start controller connected")
    console.log("Modal target found:", this.hasModalTarget)
    console.log("Step targets found:", this.stepTargets.length)
    console.log("Step content targets found:", this.stepContentTargets.length)
    console.log("Script panel target found:", this.hasScriptPanelTarget)
    this.currentStep = 1
    this.totalSteps = this.stepTargets.length
  }
  
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
  
  closeModal(event) {
    if (event) event.preventDefault()
    console.log("Closing modal")
    this.modalTarget.classList.remove('active')
    document.body.style.overflow = ''
  }
  
  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.closeModal()
    }
  }
  
  nextStep(event) {
    event.preventDefault()
    
    if (this.currentStep < this.totalSteps) {
      this.goToStep(this.currentStep + 1)
    }
  }
  
  prevStep(event) {
    event.preventDefault()
    
    if (this.currentStep > 1) {
      this.goToStep(this.currentStep - 1)
    }
  }
  
  goToStep(stepNumber) {
    // Update current step
    this.currentStep = stepNumber
    
    // Update step indicators
    this.stepTargets.forEach((step, index) => {
      const stepNum = index + 1
      
      if (stepNum === this.currentStep) {
        step.classList.add('active')
        step.classList.remove('completed')
      } else if (stepNum < this.currentStep) {
        step.classList.remove('active')
        step.classList.add('completed')
      } else {
        step.classList.remove('active')
        step.classList.remove('completed')
      }
    })
    
    // Update step content
    this.stepContentTargets.forEach((content) => {
      if (parseInt(content.dataset.step) === this.currentStep) {
        content.classList.add('active')
      } else {
        content.classList.remove('active')
      }
    })
    
    // Update buttons
    this.prevButtonTarget.disabled = this.currentStep === 1
    
    if (this.currentStep === this.totalSteps) {
      this.nextButtonTarget.style.display = 'none'
      this.finishButtonTarget.style.display = 'block'
    } else {
      this.nextButtonTarget.style.display = 'block'
      this.finishButtonTarget.style.display = 'none'
    }
    
    // Hide script panel when changing steps
    if (this.hasScriptPanelTarget) {
      this.scriptPanelTarget.style.display = 'none'
    }
  }
  
  finishSetup(event) {
    event.preventDefault()
    
    // Here you would typically save the configuration and redirect
    // For now, we'll just close the modal and show a success message
    this.closeModal()
    
    // Show success notification
    this.showNotification('success', 'Dashboard Created!', 'Your new dashboard has been set up successfully.')
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
  
  // Script Panel Methods
  toggleScriptVisibility(event) {
    event.preventDefault()
    console.log("Toggling script panel visibility - SIMPLIFIED VERSION")
    
    // Approche directe avec getElementById
    const scriptPanel = document.getElementById('scriptContentPanel')
    console.log("Script panel found by ID:", scriptPanel)
    
    if (!scriptPanel) {
      console.error("Script panel not found by ID!")
      return
    }
    
    // Toggle display
    if (scriptPanel.style.display === 'none' || scriptPanel.style.display === '') {
      scriptPanel.style.display = 'block'
      console.log("Panel shown (direct approach)")
    } else {
      scriptPanel.style.display = 'none'
      console.log("Panel hidden (direct approach)")
    }
    
    // Update button text if needed
    const viewButton = document.getElementById('viewScriptButton')
    if (viewButton) {
      if (scriptPanel.style.display === 'block') {
        viewButton.innerHTML = '<i class="fas fa-eye-slash"></i> Hide Script'
      } else {
        viewButton.innerHTML = '<i class="fas fa-eye"></i> View Script'
      }
    }
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
  
  showNotification(type, title, message) {
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
  
  closeNotification(notification) {
    notification.classList.add('fade-out')
    setTimeout(() => {
      notification.remove()
    }, 300)
  }
} 