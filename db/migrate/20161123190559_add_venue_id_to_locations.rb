class AddVenueIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :venue_id, :string
  end
  #add_index :locations, :venue_id, unique: true
end
