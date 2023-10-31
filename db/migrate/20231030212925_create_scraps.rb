class CreateScraps < ActiveRecord::Migration[7.0]
  def change
    create_table :scraps do |t|
      t.text :keywords
      t.text :urls

      t.timestamps
    end
  end
end
