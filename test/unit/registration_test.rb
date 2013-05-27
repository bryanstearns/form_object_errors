require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  test "initialization, getters" do
    @registration = Registration.new(name: 'Bob Smith', login: 'bobby')
    assert_equal 'Bob Smith', @registration.name
    assert_equal 'bobby', @registration.login
    assert @registration.user.is_a?(User)
    assert_equal 'Bob Smith', @registration.user.name
    assert_equal 'bobby', @registration.user.login
  end

  test "adding and merging errors" do
    @registration = Registration.new(name: 'b', login: 'b')
    assert_equal false, @registration.valid?
    assert_equal ['Name and login must be different',
                  'User Login is too short (minimum is 3 characters)',
                  'User Name is too short (minimum is 3 characters)'],
                 @registration.errors.full_messages
  end
end
