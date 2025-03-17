/**
 * Contrôleur Stimulus pour la barre latérale
 * 
 * Ce contrôleur gère toutes les fonctionnalités de la barre latérale :
 * - Expansion/réduction de la barre latérale
 * - Sauvegarde de l'état dans le localStorage
 * - Ouverture de la modal des paramètres
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "content"]

  static values = {
    expandedWidth: { type: Number, default: 250 },
    collapsedWidth: { type: Number, default: 80 },
  }
  
  /**
   * Initialise le contrôleur lors de la connexion à l'élément DOM
   */
  connect() {
    console.log("Sidebar controller connected")
    
    // Restaurer l'état de la sidebar depuis localStorage
    // this.restoreSidebarState()
    this.collapseSidebar()
    
    // Configurer le bouton d'épinglage
    this.setupPinButton()
  }
  
  expandSidebar() {
    this.sidebarTarget.classList.add('expanded')
    this.sidebarTarget.style.width = `${this.expandedWidthValue}px`
  }

  collapseSidebar() {
    this.sidebarTarget.classList.remove('expanded')
    this.sidebarTarget.style.width = `${this.collapsedWidthValue}px`
  }
  
  /**
   * Configure le bouton d'épinglage
   */
  setupPinButton() {
    const pinButton = this.sidebarTarget.querySelector('#pin-sidebar')
    if (pinButton) {
      pinButton.addEventListener('click', this.toggle.bind(this))
    }
  }
  
//   /**
//    * Bascule l'état de la sidebar (expanded/collapsed)
//    */
//   toggle() {
//     this.sidebarTarget.classList.toggle('expanded')
    
//     // Enregistrer l'état dans localStorage
//     const isExpanded = this.sidebarTarget.classList.contains('expanded')
//     localStorage.setItem('sidebarExpanded', isExpanded.toString())
    
//     // Dispatcher un événement personnalisé
//     this.dispatchToggleEvent(isExpanded)
//   }
  
//   /**
//    * Dispatche un événement personnalisé pour informer d'autres composants
//    * @param {boolean} expanded - État d'expansion de la sidebar
//    */
//   dispatchToggleEvent(expanded) {
//     const event = new CustomEvent('sidebar:toggle', {
//       detail: { expanded: expanded },
//       bubbles: true
//     })
//     this.element.dispatchEvent(event)
//   }
  
  
//   /**
//    * Ouvre la modal des paramètres
//    * @param {Event} event - L'événement de clic
//    */
//   openSettings(event) {
//     event.preventDefault()
    
//     // Trouver la modal des paramètres
//     const modal = document.getElementById('settingsModal')
//     if (!modal) {
//       console.error("Settings Modal not found")
//       return
//     }
    
//     // Ouvrir la modal
//     modal.classList.add('active')
//     document.body.style.overflow = 'hidden'
//   }
} 