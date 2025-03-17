Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.


----- Controller ---------
class GeoScoringsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_keywords
  before_action :set_selected_keyword

  def index
    if @selected_keyword
      @geo_scorings_data = calculate_provider_data(@company, @selected_keyword)
    end
  end

  def history
    @history_scores = GeoScoring.where(keyword: @selected_keyword).order(created_at: :asc)

    respond_to do |format|
      format.html { render partial: "history", locals: { history_scores: @history_scores } }
      format.json { render json: @history_scores }
    end
  end

  def new
    @geo_scoring = GeoScoring.new
    @ai_providers = AiProvider.all
    @keywords = Keyword.all
  end

  private

  def set_company
    @company = current_user.company
  end

  def set_keywords
    @keywords = @company.keywords
  end

  def set_selected_keyword
    @selected_keyword = @keywords.find_by(id: params[:keyword_id])
  end

  def calculate_provider_data(company, keyword)
    @company.ai_providers.map do |ai_provider|
      calculate_keyword_for_ai_provider_score(keyword, ai_provider)
    end
  end

  def calculate_keyword_for_ai_provider_score(keyword, ai_provider)
    geo_scorings = GeoScoring.where(keyword: keyword, ai_provider: ai_provider)
    {
      name: ai_provider.name,
      score: geo_scorings.average(:score).to_f,
      mention_score: geo_scorings.where(mentioned: true).count.fdiv(geo_scorings.count) * 100,
      position_score: geo_scorings.average(:position).to_f,
      url_presence_score: geo_scorings.where.not(url: nil).count.fdiv(geo_scorings.count) * 100
    }
  end

end


---model geoscoring
class GeoScoring < ApplicationRecord
  attr_accessor :prompt
  belongs_to :ai_provider
  belongs_to :keyword

  validates :score, numericality: true, allow_nil: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :mentioned, inclusion: { in: [true, false] }

  before_save :calculate_position, :calculate_score
  after_save :update_keyword_scores

  def self.calculate_all_scores
    Keyword.all.each do |keyword|
      AiProvider.all.each do |provider|
        GeoScoring.create_or_update_score(keyword, provider)
      end
    end
  end

  def self.create_or_update_score(keyword, provider)
    geo_scoring = GeoScoring.find_or_initialize_by(keyword: keyword, ai_provider: provider)
    geo_scoring.update_score(keyword, provider)
  end

  def update_score(keyword, provider)
    # Logique pour mettre à jour le score
  end
end






-----seed --------
# Nettoyage de la base de données
CompanyAiProvider.destroy_all
CompetitorScore.destroy_all
GeoScoring.destroy_all
Competitor.destroy_all
Request.destroy_all
Keyword.destroy_all
AiProvider.destroy_all
User.destroy_all
Company.destroy_all
puts "seed destroyed"

companies = Company.create!([
  { name: "Le Wagon Bar", domain: "https://www.lewagon.com", token: 'c52cf53345ce51d8e20ad727386e239a' },
  { name: "Airbnb", domain: "https://www.airbnb.com" },
  { name: "Uber", domain: "https://www.uber.com" },
  { name: "Spotify", domain: "https://www.spotify.com" },
  { name: "GitHub", domain: "https://www.github.com" }
])
puts "Company created"

company = Company.first

# Utilisateurs avec company associée
ben = User.create!(email: "ben@gmail.com", password: "password1", company: company)
anh = User.create!(email: "anh@gmail.com", password: "password2", company: company)
antoine = User.create!(email: "antoine@gmail.com", password: "password3", company: company)
yannick = User.create!(email: "yannick@gmail.com", password: "password4", company: company)
test = User.create!(email: "test@test.com", password: "azerty", company: company)

# Utilisateurs sans company associée (pour tester la modal QuickStart)
noCompany = User.create!(email: "nocompany@gmail.com", password: "azerty", company: nil)
puts "Users created"

ai_providers = AiProvider.create!([
  { name: "openai" },
  { name: "anthropic" },
  { name: "perplexity" }
])


companies = Company.all
keywords = Keyword.create!([
  { content: "Meilleure formation en intelligence artificielle en ligne", company: company },
  { content: "Meilleur bootcamp de Machine Learning ?", company: company },
  { content: "Top écoles pour apprendre la Data Science", company: company },
  { content: "Formation Cloud Computing la plus reconnue en 2025", company: company },
  { content: "Comparaison des meilleures formations en automatisation des tâches", company: company }
])
puts "Keywords created"

AiProvider.find_each do |ai_provider|
  CompanyAiProvider.create!(company: company, ai_provider: ai_provider)
end
puts "Association done"

# Création des requêtes sur 3 jours
end_time = Time.now - 10.minutes
(Date.new(2024, 9, 1)..end_time.to_date).each do |date|
  max_hour = date == end_time.to_date ? end_time.hour : 23
  ["https://www.chatgpt.com", "http://www.claude.ai", "http://www.perplexity.ai"].each do |referrer|
    rand(5..15).times do |i|
      created_time = date.to_time + rand(max_hour + 1).hours

      next if created_time > end_time

      Request.create!(
        domain: ["https://www.lewagon.com", "https://www.airbnb.com", "https://www.uber.com", "https://www.github.com"].sample,
        path: ["/learn", "/repos"],
        user_agent: "Mozilla/5.0",
        company: company,
        created_at: created_time,
        referrer: referrer
      )
      puts "request n°#{Request.count} created"
    end
  end
end
puts "requests created"

competitors = Competitor.create!([
  { name: "Competitor 1", domain: "https://www.competitor1.com", company: company },
  { name: "Competitor 2", domain: "https://www.competitor2.com", company: company  },
  { name: "Competitor 3", domain: "https://www.competitor3.com", company: company  },
  { name: "Competitor 4", domain: "https://www.competitor4.com", company: company  },
  { name: "Competitor 5", domain: "https://www.competitor5.com", company: company  }
])
puts "Competitors created"

keywords = Keyword.all


puts "geo_scoring historiques créés"

# Création des geo_scorings actuels pour les scores des concurrents
current_geo_scorings = []

puts "geo_scoring actuels créés"

# Création des geo_scorings pour chaque mot-clé et fournisseur d'IA
puts "Creating geo_scorings..."

urls = ['https://www.le-wagon-bar.vercel.app/', 'https://www.google.com/', nil]
(Date.new(2024, 9, 1)..Date.today).each do |date|
  company.keywords.each do |keyword|
    company.ai_providers.each do |ai_provider|
      mention = (rand(10) % 2).even?
      GeoScoring.create!(
        keyword: keyword,
        ai_provider: ai_provider,
        mentioned: mention,
        ai_responses: ['wagon', 'google', 'le wagon bar', 'openclassrooms'].shuffle,
        url: urls.sample,
        created_at: date
      )
    end
  end
end

puts "Finished creating geo_scorings!"


----------- index ---------
<div class="dashboard-container">
  <div class="main-content">
    <!-- Header -->
    <header class="dashboard-header">
      <div class="header-top">
        <div class="welcome-text">
          <h1>Analysis of <span class="gradient-text">positioning</span></h1>
          <p class="date"><%= Date.today.strftime("%A %d %B %Y") %></p>
        </div>
      </div>

      <!-- Search bar -->
      <div class="search-bar-container">
        <div class="search-bar modern-search-bar">
          <i class="fas fa-search"></i>
          <%= form_with url: geo_scorings_path, method: :get, local: true, class: "search-form" do |f| %>
            <%= f.select :keyword_id,
                        options_from_collection_for_select(@keywords, :id, :content, @selected_keyword&.id),
                        { include_blank: "Search for a prompt..." },
                        {
                          class: "search-input modern-input",
                          onchange: "this.form.submit()"
                        }
            %>
          <% end %>
        </div>
      </div>
    </header>

    <% if @keywords.present? && @selected_keyword.present? %>
      <div class="dashboard-sections">
        <!-- Overview section -->
        <section class="info-section">
          <div class="cards-grid">

            <!-- Global score card -->
            <div class="action-card" data-controller="flip-card">
              <div class="card-back">
                <div class="card-header">
                  <h3>Global Score</h3>
                </div>
                <p>Average score across providers</p>
                <div>
                  <%= render 'score_details', position_score: 78, frequency_score: 65, link_score: 92 %>
                </div>
              </div>
              <div class="card-front">
                <div class="card-header">
                  <h3>Score Details</h3>
                </div>
                <div class="score-display">
                  <div class="score-circle success">
                    <span class="score-value">85%</span>
                  </div>
                  <p class="score-label">Global score</p>
                </div>
                <div class="details-content">
                  <p>This represents the average performance across all AI providers.</p>
                  <p>Click again to return to the front.</p>
                </div>
              </div>
            </div>
          </div>
        </section>


        <section class="results-section">
          <div class="section-header">
            <h2>Results by AI Provider</h2>
            <p>Detailed score analysis</p>
          </div>
          <div class="cards-grid">
            <% @geo_scorings_data.each do |provider_data| %>
              <div class="action-card" data-controller="flip-card">
                <div class="card-front">
                  <div class="card-header">
                    <h3><%= provider_data[:name].capitalize %></h3>
                    <img src="<%= asset_path("#{provider_data[:name].downcase}_logo.png") %>" alt="<%= provider_data[:name] %> logo" class="provider-logo">
                  </div>
                  <div class="score-display">
                    <div class="score-circle <%= score_color_class(provider_data[:score]) %>">
                      <span class="score-value"><%= provider_data[:score].round %>%</span>
                    </div>
                    <p class="score-label">Global score</p>
                  </div>
                </div>
                <div class="card-back">
                  <div class="card-header">
                    <h3>Details for <%= provider_data[:name].capitalize %></h3>
                  </div>
                  <div class="details-content">
                    <p>This score is based on several factors, including position, frequency, and link building.</p>
                  </div>
                  <div>
                   <ul>
                    <li><strong>Position score</strong>: <%= provider_data[:position_score] %>%</li>
                    <li><strong>Reference score</strong>: <%= provider_data[:reference_score] %>%</li>
                    <li><strong>URL presence</strong>: <%= provider_data[:url_presence] ? "Yes" : "No" %></li>
                  </ul>
                </div>
                </div>
              </div>
            <% end %>
          </div>
        </section>

        <!-- Filtres de recherche -->
      <div class="mt-2"
           data-controller="requests-stream"
           data-requests-stream-company-id-value="<%= @company.id%>">
        <%= simple_form_for :search,
                            url: requests_path,
                            method: :get,
                            html: {
                              class: 'form-inline w-100',
                              data: {
                                requests_stream_target: 'form',
                                turbo_frame: 'request-chart'
                              }
                            } do |f| %>
          <div class="d-flex gap-2">
            <%= f.input :ai_provider,
                        collection: AiProvider.all,
                        include_blank: "All AI Providers",
                        wrapper_html: {
                          class: 'modern-search-bar'
                        },
                        input_html: {
                          class:'form-control',
                          value: params.dig(:search, :ai_provider),
                          data: { action: 'change->requests-stream#submitForm' }
                        } %>
            <%= f.input :timeline,
                        collection: [
                          ['Today', 'today'],
                          ['1 Week', '1_week'],
                          ['1 Month', '1_month'],
                          ['3 Months', '3_months'],
                          ['6 Months', '6_months']
                        ],
                        include_blank: "Select Time",
                        wrapper_html: {
                          class:'modern-search-bar'
                        },
                        input_html: {
                          class:'form-control',
                          value: params.dig(:search, :timeline),
                          data: { action: 'change->requests-stream#submitForm' }
                        } %>
          </div>
        <% end %>
      </div>

        <!-- Graphique et métriques -->
    <turbo-frame id="request-chart">
      <div style="display: flex; gap: 20px;">
        <!-- Graphique (côté gauche) -->
        <div style="flex: 1; min-width: 0;">
          <div class="card hoverable">
            <div class="card-header">
              <h3>Requests Over Time</h3>
            </div>
            <div class="card-body">
              <div class="chart-container" style="height: 490px;">
                <%= line_chart @requests_by_date_and_ai_provider,
                    curve: false,
                    points: false,
                    height: "450px",
                    colors: ["#d88c9a", "#f2d0a9", "#f1e3d3", "#99c1b9", "#8e7dbe", "#EC4899"],
                    library: {
                      chart: {
                        backgroundColor: '#f8f9fa',
                        borderRadius: 2
                      },
                      title: {
                        text: nil
                      },
                      legend: {
                        align: 'center',
                        verticalAlign: 'bottom',
                        layout: 'horizontal',
                        symbolHeight: 12,
                        symbolWidth: 12,
                        symbolRadius: 6
                      },
                      xAxis: {
                        labels: {
                          style: {
                            fontSize: '12px'
                          }
                        }
                      },
                      yAxis: {
                        title: {
                          text: 'Number of Visits'
                        },
                        min: 0
                      },
                      tooltip: {
                        shared: true,
                        crosshairs: true
                      }
                    },
                    xtitle: "Time",
                    ytitle: "Visits",
                    id: 'requests' %>
              </div>
            </div>
          </div>
        </div>
      </div>

    <% else %>
      <!-- Empty state -->
      <div class="empty-state">
        <div class="empty-state-content">
          <i class="fas fa-search"></i>
          <h3>No keyword selected</h3>
          <p>Please select a keyword in the search bar above to see the positioning analysis.</p>
        </div>
      </div>
    <% end %>
  </div>
</div>
