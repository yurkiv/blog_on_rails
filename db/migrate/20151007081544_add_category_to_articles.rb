class AddCategoryToArticles < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.string :category_id
    end
  end

  def down
    change_table :articles do |t|
      t.remove :category_id
    end
  end
end
