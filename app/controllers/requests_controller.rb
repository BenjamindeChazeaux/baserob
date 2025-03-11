class RequestsController < ApplicationController
  def index
    @requests = Request.all
  end

  def show
    @request = Request.find(params[:id])
  end

  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      redirect_to @request
    else
      render :edit
    end
  end

  private

  def request_params
    params.require(:request).permit(:attribute1, :attribute2)
  end
end
