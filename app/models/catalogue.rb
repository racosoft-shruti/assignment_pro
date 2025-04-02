# == Schema Information
#
# Table name: catalogues
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  hide_days   :datetime
#  user_id     :integer
#

class Catalogue < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
end
