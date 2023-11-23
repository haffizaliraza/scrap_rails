class AddAvatarToDocument < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :avatar, :string
  end
end
