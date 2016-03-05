class Room < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :players
end