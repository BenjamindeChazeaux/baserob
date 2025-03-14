class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = current_user.build_company(company_params)
    
    respond_to do |format|
      if @company.save
        current_user.update(company: @company)
        format.json { render json: { success: true, message: 'Company created successfully' } }
      else
        format.json do 
          render json: {
            success: false, 
            message: @company.errors.full_messages.join(', '), 
            formHTML: render_to_string(partial: 'companies/form', locals: { company: @company }, formats: [:html])
          }, 
          status: :unprocessable_entity 
        end
      end
    end
  end

  def edit
    @companie = companie.find(params[:id])
  end

  def update
    @company = current_user.company
    
    respond_to do |format|
      if @company.update(company_params)
        # Mettre à jour le statut "needs_setup" de l'utilisateur
        current_user.update(needs_setup: false)
        
        format.json { render json: { success: true, message: 'Company updated successfully' } }
      else
        format.json { render json: { success: false, message: @company.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_path, notice: "Company was successfully destroyed."
  end

  private

  def company_params
    params.require(:company).permit(:name, :domain)
  end
end
