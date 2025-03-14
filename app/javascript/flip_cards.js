// Attendre que le DOM soit complètement chargé
document.addEventListener('DOMContentLoaded', function() {
  // Sélectionner toutes les cartes avec la classe flip-card
  const flipCards = document.querySelectorAll('.flip-card');

  // Ajouter un écouteur d'événements à chaque carte
  flipCards.forEach(card => {
    card.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      console.log('Carte cliquée'); // Pour le débogage
      this.classList.toggle('flipped');
    });
  });
});
