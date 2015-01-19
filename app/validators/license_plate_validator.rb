
class LicensePlateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[A-Z]{3}\d{3}\z/i
      record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.models.vehicle.attributes.license_plate.invalid'))
    end
  end
end