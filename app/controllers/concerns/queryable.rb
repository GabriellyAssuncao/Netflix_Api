module Queryable
  extend ActiveSupport::Concern

  class_methods do
    def query(params = {})
      query = all

      filterable_params.each do |key|
        value = params[key]

        if key == "published_at" && value.present?
          value = parse_date(value)
        end

        if key == "description" && value.present?
          query = query.where("description LIKE ?", "%#{value}%")
        else
          mapped_key = field_mapping[key] || key
          query = query.where(mapped_key => value) if value.present?
        end
      end

      query.order(release_year: :asc)
    end

    private

    def filterable_params
      []
    end

    def field_mapping
      {}
    end

    def parse_date(value)
      case value
      when /^\d{4}-\d{2}-\d{2}$/
        Date.strptime(value, "%Y-%m-%d")
      when /^\d{2}-\d{2}-\d{4}$/
        Date.strptime(value, "%d-%m-%Y")
      when %r{^\d{2}/\d{2}/\d{4}$}
        Date.strptime(value, "%d/%m/%Y")
      end
    end
  end
end


