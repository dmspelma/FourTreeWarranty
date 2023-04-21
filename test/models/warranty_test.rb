# frozen_string_literal: true

require 'test_helper'

# Tests the warranty object
class WarrantyTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: 'test@example.com', password: 'test1234')

    @valid_params = {
      warranty_name: 'robinhood',
      warranty_company: 'thisfoxcodes',
      warranty_start_date: Date.current,
      extra_info: 'something.',
      user_id: @user.id
    }
  end

  test 'Warranty name must be valid' do
    short_name = Warranty.new(
      warranty_name: 'A',
      warranty_company: 'Test',
      warranty_start_date: Date.current,
      user_id: @user.id
    )
    long_name = Warranty.new(
      warranty_name: 'A' * 51,
      warranty_company: 'Test',
      warranty_start_date: Date.current,
      user_id: @user.id
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      short_name.save!
    end
    assert short_name.errors.messages[:warranty_name], ['is too short (minimum is 2 characters)']

    assert_raises(ActiveRecord::RecordInvalid) do
      long_name.save!
    end
    assert long_name.errors.messages[:warranty_name], ['is too long (maximum is 50 characters)']
  end

  test 'Warranty company must be valid' do
    short_name = Warranty.new(
      warranty_name: 'A',
      warranty_company: 'Test',
      warranty_start_date: Date.current,
      user_id: @user.id
    )
    long_name = Warranty.new(
      warranty_name: 'A' * 51,
      warranty_company: 'Test',
      warranty_start_date: Date.current,
      user_id: @user.id
    )

    assert_raises(ActiveRecord::RecordInvalid) do
      short_name.save!
    end
    assert short_name.errors.messages[:warranty_name], ['is too short (minimum is 2 characters)']

    assert_raises(ActiveRecord::RecordInvalid) do
      long_name.save!
    end
    assert long_name.errors.messages[:warranty_name], ['is too long (maximum is 50 characters)']
  end

  test 'User_id must exist' do
    invalid_user_params = @valid_params.dup
    invalid_user_params[:user_id] = 0

    invalid_warranty = Warranty.new(invalid_user_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert invalid_warranty.errors.messages[:user_id], ['must exist']
  end

  test 'Warranty_start_date cannot be null' do
    invalid_start_params = @valid_params.dup
    invalid_start_params[:warranty_start_date] = nil

    invalid_warranty = Warranty.new(invalid_start_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert invalid_warranty.errors.messages[:warranty_start_date], ['is not a valid date']
  end

  test 'Warranty_end_date can be nil' do
    @valid_params[warranty_end_date: nil]

    assert Warranty.new(@valid_params).save
  end

  test 'Warranty_end_date must be after warranty_start_date' do
    invalid_end_params = @valid_params.dup
    invalid_end_params[:warranty_end_date] = Date.current - 1.days

    invalid_warranty = Warranty.new(invalid_end_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert invalid_warranty.errors.messages, ['end date must be after start date']

    valid_end_date = @valid_params.dup
    valid_end_date[:warranty_end_date] = Date.current + 1.day

    valid_warranty = Warranty.new(valid_end_date)
    assert valid_warranty.save
  end

  test 'Cannot save warranty without necessary params' do
    empty_warranty = Warranty.new
    assert_raises(ActiveRecord::RecordInvalid) do
      empty_warranty.save!
    end

    expected_errors = {
      user: ['must exist'],
      warranty_name: ['can\'t be blank', 'is too short (minimum is 2 characters)'],
      warranty_company: ['can\'t be blank', 'is too short (minimum is 2 characters)'],
      warranty_start_date: ['is not a valid date'],
      user_id: ['can\'t be blank']
    }

    assert_equal empty_warranty.errors.messages, expected_errors
  end

  test 'don\'t allow too long extra_info' do
    long_extra_info = @valid_params.dup
    long_extra_info[:extra_info] = 'A' * 251

    invalid_warranty = Warranty.new(long_extra_info)

    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert invalid_warranty.errors.messages[:extra_info], ['is too long (maximum is 250 characters)']
  end

  test 'Save valid warranty' do
    total = Warranty.count

    assert Warranty.new(@valid_params).save

    assert total + 1, Warranty.count
  end

  test 'Cannot update invalid warranty' do
    warranty = Warranty.create(@valid_params)

    too_short_params = {
      warranty_name: 'A',
      warranty_company: 'B'
    }
    no_params = {
      warranty_name: '',
      warranty_company: ''
    }
    no_start_date = {
      warranty_start_date: nil
    }
    long_extra_info = {
      extra_info: 'A' * 251
    }

    assert_raises(ActiveRecord::RecordInvalid) do
      warranty.update!(too_short_params)
    end
    assert_raises(ActiveRecord::RecordInvalid) do
      warranty.update!(no_params)
    end
    assert_raises(ActiveRecord::RecordInvalid) do
      warranty.update!(no_start_date)
    end
    assert_raises(ActiveRecord::RecordInvalid) do
      warranty.update!(long_extra_info)
    end
  end

  test 'Update valid warranty' do
    warranty = Warranty.create!(@valid_params)
    new_params = {
      warranty_name: 'Malibu Barbie',
      warranty_company: 'Hasbro'
    }

    assert warranty.update!(new_params)
  end

  test 'destroy warranty' do
    warranty = Warranty.create!(@valid_params)
    total = Warranty.count

    assert warranty.destroy
    assert total - 1, Warranty.count
  end
end
