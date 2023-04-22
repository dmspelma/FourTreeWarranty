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
    assert_equal short_name.errors.messages[:warranty_name], ['is too short (minimum is 2 characters)']

    assert_raises(ActiveRecord::RecordInvalid) do
      long_name.save!
    end
    assert_equal long_name.errors.messages[:warranty_name], ['is too long (maximum is 50 characters)']
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
    assert_equal short_name.errors.messages[:warranty_name], ['is too short (minimum is 2 characters)']

    assert_raises(ActiveRecord::RecordInvalid) do
      long_name.save!
    end
    assert_equal long_name.errors.messages[:warranty_name], ['is too long (maximum is 50 characters)']
  end

  test 'User_id must exist' do
    invalid_user_params = @valid_params.dup
    invalid_user_params[:user_id] = 0

    invalid_warranty = Warranty.new(invalid_user_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:user], ['must exist']
  end

  test 'Warranty_start_date must be valid' do
    nil_start_params = @valid_params.dup
    nil_start_params[:warranty_start_date] = nil

    invalid_start_params = @valid_params.dup
    invalid_start_params[:warranty_start_date] = '2023-xx-xx'

    nil_warranty = Warranty.new(nil_start_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      nil_warranty.save!
    end
    assert_equal nil_warranty.errors.messages[:warranty_start_date], ['is not a valid date']

    invalid_warranty = Warranty.new(invalid_start_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:warranty_start_date], ['is not a valid date']
  end

  test 'Warranty_end_date must be valid' do
    nil_start_params = @valid_params.dup
    nil_start_params[:warranty_end_date] = nil

    invalid_end_params = @valid_params.dup
    invalid_end_params[:warranty_end_date] = '2023-xx-xx'

    assert Warranty.new(nil_start_params).save

    invalid_warranty = Warranty.new(invalid_end_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:warranty_end_date], ['end date must be after start date']
  end

  test 'Warranty_end_date must be after warranty_start_date' do
    invalid_end_params = @valid_params.dup
    invalid_end_params[:warranty_end_date] = Date.current - 1.days

    invalid_warranty = Warranty.new(invalid_end_params)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:warranty_end_date], ['end date must be after start date']

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
    assert_equal invalid_warranty.errors.messages[:extra_info], ['is too long (maximum is 250 characters)']
  end

  test 'Save valid warranty' do
    total = Warranty.count

    assert Warranty.new(@valid_params).save

    assert_equal total + 1, Warranty.count
  end

  test 'Cannot update invalid warranty' do
    too_short_warranty = Warranty.create(@valid_params)
    no_params_warranty = Warranty.create(@valid_params)
    no_start_warranty = Warranty.create(@valid_params)
    long_info_warranty = Warranty.create(@valid_params)

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
      too_short_warranty.update!(too_short_params)
    end
    assert_equal too_short_warranty.errors.messages.count, 2

    assert_raises(ActiveRecord::RecordInvalid) do
      no_params_warranty.update!(no_params)
    end
    assert_equal no_params_warranty.errors.messages.count, 2

    assert_raises(ActiveRecord::RecordInvalid) do
      no_start_warranty.update!(no_start_date)
    end
    assert_equal no_start_warranty.errors.messages.count, 1

    assert_raises(ActiveRecord::RecordInvalid) do
      long_info_warranty.update!(long_extra_info)
    end
    assert_equal long_info_warranty.errors.messages.count, 1
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
    assert_equal total - 1, Warranty.count
  end
end
