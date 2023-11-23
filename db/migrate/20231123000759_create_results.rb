class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.references :document, null: false, foreign_key: true
      t.json :urls

      t.timestamps
    end
  end
end
