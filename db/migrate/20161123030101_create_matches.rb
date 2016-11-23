class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_contender_id
      t.integer :visitor_contender_id
      t.datetime :date_and_time
      t.integer :home_contender_score
      t.integer :visitor_contender_score

      t.timestamps null: false
    end
  end
end
