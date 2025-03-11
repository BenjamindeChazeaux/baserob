class CompaniesController < ApplicationController
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
    @company = Company.new(company_params)
    if @company.save
      redirect_to companies_path, notice: "Company was successfully created."
    else
      render :new
    end
  end

  def edit
    @companie = companie.find(params[:id])
  end

  def update
    @companie = companie.find(params[:id])
    if @company.update(company_params)
      redirect_to companies_path, notice: "Company was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_path, notice: "Company was successfully destroyed."
  end

  private

  def company_params
    params.require(:company).permit(:nam, :adress, :description)
  end
