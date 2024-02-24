class Router < ApplicationRecord
  belongs_to :location
  has_many :router_links, dependent: :destroy
  has_many :linked_routers, through: :router_links
end
