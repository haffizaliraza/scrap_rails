class AddBaseUrlToResult < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :base_url, :string
  end
end
