class CreateRouterLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :router_links do |t|
      t.references :router, foreign_key: true
      t.references :linked_router, foreign_key: { to_table: :routers }

      t.timestamps
    end
  end
end


