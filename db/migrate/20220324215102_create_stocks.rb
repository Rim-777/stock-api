class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks, id: :uuid do |t|
      t.references :bearer, type: :uuid, index: true, foreign_key: true
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
