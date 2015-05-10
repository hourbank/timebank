class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :provided_by_id
      t.integer :received_by_id
      t.decimal :estimated_hours
      t.decimal :final_hours
      t.text :description
      t.boolean :proposed
      t.datetime :proposed_date
      t.boolean :accepted
      t.datetime :accepted_date
      t.boolean :delivered
      t.datetime :delivered_date
      t.boolean :confirmed
      t.datetime :confirmed_date
      t.integer :service_requested_id

      t.timestamps null: false
    end
  end
end
