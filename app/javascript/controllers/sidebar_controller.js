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
    console.log("Sidebar controller connected");
    this.initializeSidebar();
    this.setupEventListeners();
  }
  
  initializeSidebar() {
    // Vérifier si l'état est enregistré dans localStorage
    if (localStorage.getItem('sidebarExpanded') === 'true') {
      this.sidebarTarget.classList.add('expanded');
    }
    
    // Masquer tous les sous-menus au chargement
    document.querySelectorAll('.submenu').forEach(submenu => {
      submenu.style.display = "none";
    });
  }
  
  setupEventListeners() {
    // Gestion du bouton d'épinglage
    const pinButton = this.sidebarTarget.querySelector('#pin-sidebar');
    if (pinButton) {
      pinButton.addEventListener('click', this.togglePin.bind(this));
    }
    
    // Gestion des sous-menus
    document.querySelectorAll('.nav-item-with-submenu > a').forEach(link => {
      link.addEventListener('click', this.toggleSubmenu.bind(this));
    });
  }
  
  togglePin(event) {
    if (event) {
      event.stopPropagation();
    }
    
    this.sidebarTarget.classList.toggle('expanded');
    
    // Enregistrer l'état dans localStorage
    localStorage.setItem('sidebarExpanded', this.sidebarTarget.classList.contains('expanded'));
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