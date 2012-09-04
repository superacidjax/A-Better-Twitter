class AddGroupToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :group_id, :integer, default: 1
  end
end
