class AddJsonFieldToScrap < ActiveRecord::Migration[7.0]
  def change
    add_column :scraps, :results, :json
  end
end
