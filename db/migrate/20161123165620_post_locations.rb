class PostLocations < ActiveRecord::Migration
  def change
    create_table :post_locations do |t|
      t.references :post
      t.references :location
    end
  end
end
