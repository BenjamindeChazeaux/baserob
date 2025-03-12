import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "addKeywordBtn", "existingKeywords"];

  toggleAddIcon() {
    const inputValue = this.inputTarget.value.trim();
    this.addKeywordBtnTarget.disabled = inputValue === "";
  }

  addKeyword(event) {
    event.preventDefault();
    const keyword = this.inputTarget.value.trim();

    if (keyword === "") return;

    fetch("/keywords", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ keyword: { content: keyword } })
    })
    .then(response => response.json())
    .then(data => {
      if (data.id) {
        const newOption = document.createElement("option");
        newOption.value = data.id;
        newOption.textContent = data.content;
        this.existingKeywordsTarget.appendChild(newOption);

        this.inputTarget.value = "";
        this.addKeywordBtnTarget.disabled = true;
      }
    })
    .catch(error => console.error("Error adding keyword:", error));
  }

  selectKeyword(event) {
    const keywordId = event.target.value;
    if (keywordId) {
      fetch(`/geo_scorings?keyword_id=${keywordId}`, { headers: { "Accept": "text/vnd.turbo-stream.html" } })
        .then(response => response.text())
        .then(html => Turbo.renderStreamMessage(html));
    }
  }
}
