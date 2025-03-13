require 'rails_helper'

RSpec.describe GeoScoringsController, type: :controller do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:ai_provider) { create(:ai_provider) }
  let(:company_ai_provider) { create(:company_ai_provider, company: company, ai_provider: ai_provider) }
  let(:keyword) { create(:keyword, company: company) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'quand un mot-clé est sélectionné' do
      let!(:current_scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          position_score: 80,
          ai_responses: ['Competitor 1', company.name, 'Competitor 2'],
          created_at: Time.current
        )
      end

      let!(:previous_scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          position_score: 70,
          ai_responses: ['Competitor 1', 'Competitor 2', company.name],
          created_at: 1.day.ago
        )
      end

      it 'calcule correctement les données du fournisseur' do
        get :index, params: { keyword_id: keyword.id }

        expect(assigns(:ai_provider_data).first).to include(
          name: ai_provider.name,
          company_position: 1,
          position_change: 10,
          current_score: 80,
          previous_score: 70
        )
      end

      it 'calcule correctement le score global' do
        get :index, params: { keyword_id: keyword.id }

        expect(assigns(:global_score)).to eq(80.0)
        expect(assigns(:global_position_change)).to eq(10.0)
      end
    end

    context 'quand aucun mot-clé n\'est sélectionné' do
      it 'initialise les variables avec des valeurs par défaut' do
        get :index

        expect(assigns(:ai_provider_data)).to be_empty
        expect(assigns(:global_score)).to eq(0)
        expect(assigns(:global_position_change)).to eq(0)
      end
    end
  end

  describe 'private methods' do
    describe '#calculate_provider_data' do
      let(:calculator) { instance_double(GeoScoringCalculatorService) }
      let(:current_scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          position_score: 80,
          ai_responses: ['Competitor 1', company.name, 'Competitor 2']
        )
      end

      let(:previous_scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          position_score: 70,
          ai_responses: ['Competitor 1', 'Competitor 2', company.name]
        )
      end

      before do
        allow(controller).to receive(:fetch_current_scoring).and_return(current_scoring)
        allow(controller).to receive(:fetch_previous_scoring).and_return(previous_scoring)
        allow(controller).to receive(:calculate_position_change).and_return(10)
      end

      it 'retourne les données correctes du fournisseur' do
        result = controller.send(:calculate_provider_data, company_ai_provider, calculator)

        expect(result).to include(
          name: ai_provider.name,
          company_position: 1,
          position_change: 10,
          current_score: 80,
          previous_score: 70
        )
      end
    end

    describe '#fetch_current_scoring' do
      let!(:scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          created_at: Time.current
        )
      end

      it 'récupère le scoring le plus récent' do
        result = controller.send(:fetch_current_scoring, company_ai_provider)
        expect(result).to eq(scoring)
      end
    end

    describe '#fetch_previous_scoring' do
      let!(:current_scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          created_at: Time.current
        )
      end

      let!(:previous_scoring) do
        create(:geo_scoring,
          keyword: keyword,
          ai_provider: ai_provider,
          created_at: 1.day.ago
        )
      end

      it 'récupère le scoring précédent' do
        result = controller.send(:fetch_previous_scoring, company_ai_provider, current_scoring)
        expect(result).to eq(previous_scoring)
      end
    end

    describe '#calculate_position_change' do
      let(:current_scoring) { create(:geo_scoring, position_score: 80) }
      let(:previous_scoring) { create(:geo_scoring, position_score: 70) }

      it 'calcule la différence de score' do
        result = controller.send(:calculate_position_change, current_scoring, previous_scoring)
        expect(result).to eq(10)
      end

      it 'retourne 0 si un des scorings est manquant' do
        result = controller.send(:calculate_position_change, current_scoring, nil)
        expect(result).to eq(0)
      end
    end

    describe '#calculate_global_score' do
      before do
        controller.instance_variable_set(:@ai_provider_data, [
          { current_score: 80, position_change: 10 },
          { current_score: 70, position_change: 5 }
        ])
      end

      it 'calcule la moyenne des scores' do
        controller.send(:calculate_global_score)
        expect(controller.instance_variable_get(:@global_score)).to eq(75.0)
        expect(controller.instance_variable_get(:@global_position_change)).to eq(7.5)
      end
    end
  end
end
