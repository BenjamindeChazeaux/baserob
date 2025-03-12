import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["keywordDropdown"]

  loadScores(event) {
    const keywordId = event.target.value;
    if (!keywordId) return;

    // Turbo va recharger uniquement l'index
    window.location.href = `/geo_scorings?keyword_id=${keywordId}`;
  }
}
