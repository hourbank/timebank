class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.string :title
      t.text :description
      t.decimal :estimated_hours
      t.text :location
      t.text :timing
      t.integer :requested_by_id

      t.timestamps null: false
    end
  end
end
