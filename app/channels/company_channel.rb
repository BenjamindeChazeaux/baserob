class CompanyChannel < ApplicationCable::Channel
  def subscribed
    company = Company.find(params[:id])
    stream_for company
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
