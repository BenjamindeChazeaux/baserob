class ScoringChannel < ApplicationCable::Channel
  def subscribed
    stream_from "scoring_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
