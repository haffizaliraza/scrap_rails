class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.binary :xlsx_file
      t.text :keywords

      t.timestamps
    end
  end
end
