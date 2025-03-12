import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "step", "stepContent", "prevButton", "nextButton", "finishButton"]
  
  connect() {
    console.log("Quick Start controller connected")
    this.currentStep = 1
    this.totalSteps = this.stepTargets.length
  }
  
  openModal(event) {
    console.log("Opening modal")
    event.preventDefault()
    this.modalTarget.classList.add('active')
    document.body.style.overflow = 'hidden'
  }
  
  closeModal(event) {
    if (event) event.preventDefault()
    this.modalTarget.classList.remove('active')
    document.body.style.overflow = ''
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
  }
  
  finishSetup(event) {
    event.preventDefault()
    
    // Here you would typically save the configuration and redirect
    // For now, we'll just close the modal and show a success message
    this.closeModal()
    
    // Show success notification
    const notification = document.createElement('div')
    notification.className = 'notification success'
    notification.innerHTML = `
      <i class="fas fa-check-circle"></i>
      <div class="notification-content">
        <h4>Dashboard Created!</h4>
        <p>Your new dashboard has been set up successfully.</p>
      </div>
      <button class="close-notification">&times;</button>
    `
    document.body.appendChild(notification)
    
    // Remove notification after 5 seconds
    setTimeout(() => {
      notification.classList.add('fade-out')
      setTimeout(() => {
        notification.remove()
      }, 300)
    }, 5000)
  }
  
  // Handle clicks on selectable items
  selectItem(event) {
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
  
  // Close modal when clicking outside
  clickOutside(event) {
    if (event.target === this.modalTarget) {
      this.closeModal()
    }
  }
} 