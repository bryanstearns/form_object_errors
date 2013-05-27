class FormObject
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods
  attribute_method_suffix '?'

  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes.with_indifferent_access
    initialize_models
  end

  def valid?
    [super, validate_models_and_merge_errors].all?
  end

  def models_valid?
    true
  end

  def merge_model_errors
  end

  def merge_errors_from(model, name=nil)
    name ||= model.class.name.titleize + ' '
    model.errors.each do |attribute, errors_array|
      handled = block_given? && yield(model, attribute, errors_array)
      unless handled
        Array(errors_array).each do |error|
          self.errors.add(:base, "#{name}#{model.errors.full_message(attribute, error)}")
        end
      end
    end
  end

  def persisted?
    false
  end

  def save
    force_transaction do
      if valid?
        persist!
        true
      else
        false
      end
    end
  end

  private
  def validate_models_and_merge_errors
    if models_valid?
      true
    else
      merge_model_errors
      false
    end
  end

  def attribute(attr)
    @attributes[attr]
  end

  def attribute?(attr)
    value = @attributes[attr]
    if value.nil?
      false
    elsif Numeric === value || value !~ /[^0-9]/
      !value.to_i.zero?
    else
      !value.blank?
    end
  end
end
