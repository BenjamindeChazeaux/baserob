import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["avatar", "fileInput"]

  connect() {
    console.log("Settings controller connected")
  }

  previewImage(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        const img = this.avatarTarget
        img.src = e.target.result
      }
      reader.readAsDataURL(file)
    }
  }

  uploadNew() {
    this.fileInputTarget.click()
  }
}
