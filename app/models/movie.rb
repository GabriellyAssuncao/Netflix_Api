class Movie < ApplicationRecord
  include Queryable
  validates :show_id, uniqueness: true, presence: true

  def self.filterable_params
    %w[title country genre year published_at description]
  end

  def self.field_mapping
    {
      "title" => "title",
      "country" => "country",
      "genre" => "genre",
      "year" => "release_year",
      "published_at" => "date_added",
      "description" => "description"
    }
  end
end
