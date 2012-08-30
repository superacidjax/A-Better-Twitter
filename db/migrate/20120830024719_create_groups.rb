class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :category
      t.integer :user_id

      t.timestamps
    end
    add_index :groups, [:name, :category]
  end
end
