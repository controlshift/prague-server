# == Schema Information
#
# Table name: log_entries
#
#  id         :integer          not null, primary key
#  charge_id  :integer
#  message    :text
#  created_at :datetime
#  updated_at :datetime
#

class LogEntry < ApplicationRecord
  belongs_to :charge

  validates :message, presence: true
end
