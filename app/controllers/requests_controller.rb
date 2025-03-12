class RequestsController < ApplicationController
  def index
    @analytics_data = generate_analytics_data
    @visit_data = generate_visit_distribution
    @time_series_data = generate_time_series_data(
      params[:period] || 'month',
      params[:provider],
      params[:bot_type]
    )

    # Options de filtrage
    @providers = [
      'All Providers',
      'Amazon',
      'Anthropic',
      'ByteDance',
      'Common Crawl',
      'Internet Archive',
      'OpenAI',
      'Perplexity'
    ]
    
    @bot_types = [
      'All Bot Types',
      'Search Crawler',
      'AI Training Bot',
      'Content Scraper',
      'Research Bot',
      'Archive Bot'
    ]
    
    @periods = [
      { value: 'week', label: 'Past week' },
      { value: 'month', label: 'Past month' },
      { value: 'six_months', label: 'Past 6 months' },
      { value: 'year', label: 'Past year' }
    ]

    @selected_provider = params[:provider] || 'All Providers'
    @selected_bot_type = params[:bot_type] || 'All Bot Types'
    @selected_period = params[:period] || 'month'
  end

  private

  def generate_analytics_data
    {
      total_requests: rand(10000..20000),
      unique_bots: rand(50..200),
      avg_requests_per_day: rand(300..800),
      blocked_requests: rand(100..500)
    }
  end

  def generate_visit_distribution
    human = rand(60..80)
    bot = 100 - human
    {
      labels: ['Human Traffic', 'Bot Traffic'],
      datasets: [{
        data: [human, bot],
        backgroundColor: ['#4CAF50', '#2196F3']
      }]
    }
  end

  def generate_time_series_data(period, provider, bot_type)
    # Couleurs pour chaque provider
    colors = {
      'Amazon' => '#FF9900',
      'Anthropic' => '#0066FF',
      'ByteDance' => '#FF0050',
      'Common Crawl' => '#00BCD4',
      'Internet Archive' => '#9C27B0',
      'OpenAI' => '#10a37f',
      'Perplexity' => '#5436DA'
    }

    # Générer les labels de dates
    labels = case period
    when 'week'
      7.times.map { |i| (Date.today - (6 - i).days).strftime("%a %d") }
    when 'month'
      30.times.map { |i| (Date.today - (29 - i).days).strftime("%a %d") }
    when 'six_months'
      6.times.map { |i| (Date.today - i.months).strftime("%B") }.reverse
    else
      12.times.map { |i| (Date.today - (11 - i).months).strftime("%B") }
    end

    # Sélectionner les providers à afficher
    providers_to_show = if provider == 'All Providers'
      colors.keys
    else
      [provider]
    end

    # Générer les datasets
    datasets = providers_to_show.map do |prov|
      # Base pattern pour chaque provider
      base_pattern = case prov
      when 'Perplexity'
        [100, 130, 270, 50, 20, 15]
      when 'ByteDance'
        [50, 130, 80, 110, 90, 100]
      when 'Anthropic'
        [30, 40, 35, 45, 30, 25]
      else
        [20, 30, 25, 35, 40, 30]
      end

      # Générer les données en fonction de la période
      data = case period
      when 'week'
        7.times.map { |i| base_pattern[i % 6] + rand(-10..10) }
      when 'month'
        30.times.map { |i| base_pattern[i % 6] + rand(-20..20) }
      when 'six_months'
        6.times.map { |i| base_pattern[i] * (1 + rand(-0.1..0.1)) }
      else
        12.times.map { |i| base_pattern[i % 6] * (1 + rand(-0.2..0.2)) }
      end

      # Appliquer le filtre de type de bot
      if bot_type != 'All Bot Types'
        data = data.map { |v| v * rand(0.3..0.5) }
      end

      {
        label: prov,
        data: data,
        borderColor: colors[prov],
        backgroundColor: "#{colors[prov]}20",
        borderWidth: 2,
        tension: 0.4,
        fill: false
      }
    end

    {
      labels: labels,
      datasets: datasets
    }
  end
end