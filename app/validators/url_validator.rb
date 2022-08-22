# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    uri = URI.parse(value)

    record.errors.add(attribute, :invalid) unless uri.is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid)
  end
end
