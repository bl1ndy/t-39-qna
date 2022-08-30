class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :rate
      t.belongs_to :votable, polymorphic: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps

      t.check_constraint 'rate = 1 OR rate = -1'
    end

    add_index :votes, [:votable_id, :votable_type, :user_id], unique: true
  end
end
