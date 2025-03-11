class Keyword < ApplicationRecord
  belongs_to :company
  has_many :geo_scorings

  validates :company, presence: true
  validates :content, presence: true, uniqueness: { scope: :company_id, message: "This keyword is already existed" }
end
