class RouterLink < ApplicationRecord
  belongs_to :router
  belongs_to :linked_router, class_name: 'Router'
end
