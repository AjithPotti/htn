class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.decimal :required_amount
      t.decimal :amount_raised
      t.date :by_date
      t.boolean :met
      t.text :comments

      t.timestamps
    end
  end
end
