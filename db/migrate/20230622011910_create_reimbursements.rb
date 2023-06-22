class CreateReimbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :reimbursements do |t|
      t.string :cost_city_1
      t.date :start_date_1
      t.date :end_date_1

      t.string :cost_city_2
      t.date :start_date_2
      t.date :end_date_2

      t.string :cost_city_3
      t.date :start_date_3
      t.date :end_date_3

      t.string :cost_city_4
      t.date :start_date_4
      t.date :end_date_4

      t.timestamps
    end
  end
end
