/**
 * Contrôleur Stimulus pour la barre latérale
 * 
 * Gère l'affichage et le masquage des sous-menus dans la barre latérale.
 * Permet également de garder ouvert le sous-menu de la page active.
 */
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]
  
  /**
   * Initialise le contrôleur lors de la connexion à l'élément DOM
   */
  connect() {
    // Vérifier si l'état est enregistré dans localStorage
    if (localStorage.getItem('sidebarExpanded') === 'true') {
      this.sidebarTarget.classList.add('expanded')
      this.dispatchToggleEvent(true)
    } else {
      this.dispatchToggleEvent(false)
    }
    
    // Masquer tous les sous-menus au chargement
    document.querySelectorAll('.submenu').forEach(submenu => {
      submenu.style.display = "none";
    });
    
    // Ajouter un écouteur pour le bouton de pin
    const pinButton = this.sidebarTarget.querySelector('#pin-sidebar')
    if (pinButton) {
      pinButton.addEventListener('click', this.toggle.bind(this))
    }
  }
  
  // Basculer l'état de la sidebar
  toggle() {
    this.sidebarTarget.classList.toggle('expanded')
    
    // Enregistrer l'état dans localStorage
    const isExpanded = this.sidebarTarget.classList.contains('expanded')
    localStorage.setItem('sidebarExpanded', isExpanded.toString())
    
    // Dispatcher un événement personnalisé
    this.dispatchToggleEvent(isExpanded)
  }
  
  // Dispatcher un événement personnalisé pour informer d'autres composants
  dispatchToggleEvent(expanded) {
    const event = new CustomEvent('sidebar:toggle', {
      detail: { expanded: expanded },
      bubbles: true
    })
    this.element.dispatchEvent(event)
  }
  
  toggleSubmenu(event) {
    event.preventDefault();
    
    const link = event.currentTarget;
    const submenuId = link.dataset.sidebarSubmenuId;
    const submenu = document.getElementById(submenuId);
    
    if (submenu) {
      if (submenu.style.display === "none" || submenu.style.display === "") {
        submenu.style.display = "block";
        link.classList.add('active-parent');
      } else {
        submenu.style.display = "none";
        link.classList.remove('active-parent');
      }
    }
  }
} 