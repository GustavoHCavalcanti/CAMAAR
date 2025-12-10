class ResetToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  def expired?
    created_at < 2.hours.ago
  end

  private

  def generate_token
    self.token = SecureRandom.hex(20)
  end
end