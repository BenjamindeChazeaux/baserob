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
        connected: () => { console.log('connected to stream') },
        received: this.fetchNewGraphData.bind(this)
      }
    )
    setTimeout(() => {
      this.chart = Chartkick.charts['requests']
    }, 100);
  }

  fetchNewGraphData(data) {
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
    .then((data) => {
      this.chart.updateData(data.requests_data)
    })
  }
}
