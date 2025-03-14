/**
 * Contrôleur Stimulus pour la barre latérale
 * 
 * Ce contrôleur gère toutes les fonctionnalités de la barre latérale :
 * - Expansion/réduction de la barre latérale
 * - Sauvegarde de l'état dans le localStorage
 * - Gestion des sous-menus
 * - Ouverture de la modal des paramètres
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]
  
  /**
   * Initialise le contrôleur lors de la connexion à l'élément DOM
   */
  connect() {
    console.log("Sidebar controller connected")
    
    // Restaurer l'état de la sidebar depuis localStorage
    this.restoreSidebarState()
    
    // Masquer tous les sous-menus au chargement
    this.hideAllSubmenus()
    
    // Configurer le bouton d'épinglage
    this.setupPinButton()
  }
  
  /**
   * Restaure l'état de la sidebar depuis localStorage
   */
  restoreSidebarState() {
    if (localStorage.getItem('sidebarExpanded') === 'true') {
      this.sidebarTarget.classList.add('expanded')
      this.dispatchToggleEvent(true)
    } else {
      this.dispatchToggleEvent(false)
    }
  }
  
  /**
   * Masque tous les sous-menus
   */
  hideAllSubmenus() {
    document.querySelectorAll('.submenu').forEach(submenu => {
      submenu.style.display = "none"
    })
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
  
  /**
   * Bascule l'état de la sidebar (expanded/collapsed)
   */
  toggle() {
    this.sidebarTarget.classList.toggle('expanded')
    
    // Enregistrer l'état dans localStorage
    const isExpanded = this.sidebarTarget.classList.contains('expanded')
    localStorage.setItem('sidebarExpanded', isExpanded.toString())
    
    // Dispatcher un événement personnalisé
    this.dispatchToggleEvent(isExpanded)
  }
  
  /**
   * Dispatche un événement personnalisé pour informer d'autres composants
   * @param {boolean} expanded - État d'expansion de la sidebar
   */
  dispatchToggleEvent(expanded) {
    const event = new CustomEvent('sidebar:toggle', {
      detail: { expanded: expanded },
      bubbles: true
    })
    this.element.dispatchEvent(event)
  }
  
  /**
   * Bascule l'affichage d'un sous-menu
   * @param {Event} event - L'événement de clic
   */
  toggleSubmenu(event) {
    event.preventDefault()
    
    const link = event.currentTarget
    const submenuId = link.dataset.sidebarSubmenuId
    const submenu = document.getElementById(submenuId)
    
    if (submenu) {
      const isHidden = submenu.style.display === "none" || submenu.style.display === ""
      
      // Afficher ou masquer le sous-menu
      submenu.style.display = isHidden ? "block" : "none"
      
      // Ajouter ou supprimer la classe active-parent
      if (isHidden) {
        link.classList.add('active-parent')
      } else {
        link.classList.remove('active-parent')
      }
    }
  }
  
  /**
   * Ouvre la modal des paramètres
   * @param {Event} event - L'événement de clic
   */
  openSettings(event) {
    event.preventDefault()
    
    // Trouver la modal des paramètres
    const modal = document.getElementById('settingsModal')
    if (!modal) {
      console.error("Settings Modal not found")
      return
    }
    
    // Ouvrir la modal
    modal.classList.add('active')
    document.body.style.overflow = 'hidden'
  }
} 