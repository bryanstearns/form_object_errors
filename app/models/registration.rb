class Registration < FormObject
  define_attribute_methods %w[name login]

  validate :check_difference

  attr_reader :user

  def initialize_models
    @user = User.new(name: name, login: login)
  end

  def persist!
    @user.save!
  end

  def models_valid?
    @user.valid?
  end

  def merge_model_errors
    merge_errors_from(@user)
  end

private
  def check_difference
    errors.add(:base, 'Name and login must be different')\
      if name? && login? && (name == login)
  end
end
