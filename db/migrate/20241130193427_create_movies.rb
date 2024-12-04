class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :show_id
      t.string :genre
      t.string :title
      t.string :director
      t.string :country
      t.string :rating
      t.string :duration
      t.string :release_year
      t.date :date_added
      t.text :cast
      t.text :listed_in
      t.text :description

      t.timestamps
    end
  end
end
