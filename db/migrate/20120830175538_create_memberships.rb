class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :group_member_id
      t.integer :group_membership_id

      t.timestamps
    end

    add_index :memberships, :group_member_id
    add_index :memberships, :group_membership_id
    add_index :memberships, [:group_member_id, :group_membership_id],
              unique: true
  end
end
