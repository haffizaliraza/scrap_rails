class AddKeywordToResults < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :keyword, :string
  end
end
