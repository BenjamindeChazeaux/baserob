import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="requests-stream"
export default class extends Controller {
  static targets = ['form']
  static values = {
    companyId: Number
  }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: `CompanyChannel`, id: this.companyIdValue },
      {
        received: this.fetchNewGraphData.bind(this)
      }
    )
    setTimeout(() => { this.findCurrentChart() }, 100);

    this.fadeTurboFrames()
  }

  submitForm(event) {
    event.target.closest('form').requestSubmit()
  }

  fetchNewGraphData(data) {
    this.findCurrentChart()
    const formData = new FormData(this.formTarget)
    const queryParams = new URLSearchParams(formData).toString()
    const action = `${this.formTarget.action}?${queryParams}`

    const options = {
      method: 'GET',
      headers: {
        'Accept': 'application/json'
      }
    }
    fetch(action, options)
      .then(response => response.json())
      .then((newData) => {
        this.chart.updateData(newData.requests_data)
      })
  }

  findCurrentChart() {
    this.chart = Chartkick.charts['requests']
  }

  fadeTurboFrames() {
    document.addEventListener('turbo:before-frame-render', (event) => {
      if (document.startViewTransition) {
        const originalRender = event.detail.render

        event.detail.render = (currentElement, newElement) => {
          document.startViewTransition(() => originalRender(currentElement, newElement))
        }
      }
    })
  }
}
