class ResourcesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @resources = Resource.all.order(published_at: :desc)
    @featured_resource = @resources.where(featured: true).first
    @categories = Resource.distinct.pluck(:category)
  end

  def show
    @resource = Resource.find(params[:id])
    @related_resources = Resource.where(category: @resource.category)
                                .where.not(id: @resource.id)
                                .order(published_at: :desc)
                                .limit(3)
  end
end
