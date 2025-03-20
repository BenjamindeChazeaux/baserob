import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "playButton", "timer"]
  
  connect() {
    this.playing = false
    this.audioTarget.addEventListener("loadedmetadata", this.setDuration.bind(this))
    this.audioTarget.addEventListener("timeupdate", this.updateTimer.bind(this))
  }
  
  toggle(event) {
    // Empêche la propagation de l'événement au contrôleur flip-card
    event.stopPropagation()
    
    if (this.playing) {
      this.audioTarget.pause()
      this.playButtonTarget.innerHTML = '<i class="fas fa-play"></i>'
    } else {
      this.audioTarget.play()
      this.playButtonTarget.innerHTML = '<i class="fas fa-pause"></i>'
    }
    this.playing = !this.playing
  }
  
  setDuration() {
    const duration = this.formatTime(this.audioTarget.duration)
    this.timerTarget.textContent = duration
  }
  
  updateTimer() {
    const timeLeft = this.audioTarget.duration - this.audioTarget.currentTime
    this.timerTarget.textContent = this.formatTime(timeLeft)
  }
  
  formatTime(seconds) {
    const minutes = Math.floor(seconds / 60)
    const remainingSeconds = Math.floor(seconds % 60)
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`
  }
}