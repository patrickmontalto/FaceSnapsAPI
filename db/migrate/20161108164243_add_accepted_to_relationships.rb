class AddAcceptedToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :accepted, :boolean, default: true
  end
end
