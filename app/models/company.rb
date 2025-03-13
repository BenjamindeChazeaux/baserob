class Company < ApplicationRecord

  has_many :users
  has_many :competitors
  has_many :requests
  has_many :company_ai_providers
  has_many :keywords

  validates :name, presence: true, uniqueness: true
  validates :domain, presence: true, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

  # before_validation :generate_token

  # def cdn_script
  #   <<-SCRIPT
  #     <script>
  #       (function() {
  #         const apiEndpoint = '#{Rails.application.routes.url_helpers.requests_url}';
  #         const bearerToken = '#{self.token}';
  #         function collectClientInfo() {
  #           const info = {
  #             url: window.location.href,
  #             path: window.location.pathname,
  #             referrer: document.referrer,
  #             userAgent: navigator.userAgent,
  #             language: navigator.language,
  #             timestamp: new Date().toISOString(),
  #             timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
  #             platform: navigator.platform,
  #             connectionType: navigator.connection ? navigator.connection.effectiveType : 'unknown',
  #             pageLoadTime: window.performance ? window.performance.timing.domContentLoadedEventEnd - window.performance.timing.navigationStart : 'unsupported',
  #             title: document.title
  #           };
  #           try {
  #             fetch('https://api.ipify.org?format=json')
  #               .then(response => response.json())
  #               .then(data => {
  #                 info.ipAddress = data.ip;
  #                 sendDataToServer(info);
  #               })
  #               .catch(() => {
  #                 sendDataToServer(info);
  #               });
  #           } catch (e) {
  #             sendDataToServer(info);
  #           }
  #         }
  #         function sendDataToServer(data) {
  #           console.log('Sending data to server:', data);
  #           fetch(apiEndpoint, {
  #             method: 'POST',
  #             headers: {
  #               'Content-Type': 'application/json',
  #               'Authorization': 'Bearer ' + bearerToken
  #             },
  #             body: JSON.stringify(data)
  #           })
  #           .catch(error => console.error('Error sending tracking data:', error));
  #         }
  #         window.addEventListener('load', collectClientInfo);
  #         // Si vous voulez récupérer les données de navigation (back, forward, etc.) mais ca ne me semble pas utile
  #         // if (window.history && window.history.pushState) {
  #         //   const originalPushState = window.history.pushState;
  #         //   window.history.pushState = function() {
  #         //     originalPushState.apply(this, arguments);
  #         //     collectClientInfo();
  #         //   };
  #         //   window.addEventListener('popstate', collectClientInfo);
  #         // }
  #       })();
  #     </script>
  #   SCRIPT
  # end

  # private

  # def generate_token
  #   self.token = SecureRandom.hex(16)
  # end
end
