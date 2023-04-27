# frozen_string_literal: true

require 'test_helper'

# Tests the warranty object
class WarrantyTest < ActiveSupport::TestCase
  test 'Warranty name must be valid' do
    short_name = FactoryBot.build(:warranty, warranty_name: 'A')
    long_name = FactoryBot.build(:warranty, warranty_name: 'A' * 51)

    assert_raises(ActiveRecord::RecordInvalid) do
      short_name.save!
    end
    assert_not short_name.valid?
    assert_equal short_name.errors.messages[:warranty_name], ['is too short (minimum is 2 characters)']

    assert_raises(ActiveRecord::RecordInvalid) do
      long_name.save!
    end
    assert_equal long_name.errors.messages[:warranty_name], ['is too long (maximum is 50 characters)']
  end

  test 'Warranty company must be valid' do
    short_name = FactoryBot.build(:warranty, warranty_company: 'A')
    long_name = FactoryBot.build(:warranty, warranty_company: 'A' * 51)

    assert_raises(ActiveRecord::RecordInvalid) do
      short_name.save!
    end
    assert_equal short_name.errors.messages[:warranty_company], ['is too short (minimum is 2 characters)']

    assert_raises(ActiveRecord::RecordInvalid) do
      long_name.save!
    end
    assert_equal long_name.errors.messages[:warranty_company], ['is too long (maximum is 50 characters)']
  end

  test 'User_id must exist' do
    invalid_warranty = FactoryBot.build(:warranty, user_id: 0)
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:user], ['must exist']
  end

  test 'Warranty_start_date must be valid' do
    nil_warranty = FactoryBot.build(:warranty, warranty_start_date: nil)
    assert_raises(ActiveRecord::RecordInvalid) do
      nil_warranty.save!
    end
    assert_equal nil_warranty.errors.messages[:warranty_start_date], ['is not a valid date']

    invalid_warranty = FactoryBot.build(:warranty, warranty_start_date: '2023-xx-xx')
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:warranty_start_date], ['is not a valid date']
  end

  test 'Warranty_end_date defaults to nil' do
    default = FactoryBot.create(:warranty, warranty_end_date: '')
    assert_nil default.warranty_end_date

    invalid_entry = FactoryBot.create(:warranty, warranty_end_date: '2023-xx-xx')
    assert_nil invalid_entry.warranty_end_date
  end

  test 'Warranty_end_date must be after warranty_start_date' do
    invalid_warranty = FactoryBot.build(:warranty, warranty_end_date: 51.days) # start_date: 50.days.ago
    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:warranty_end_date], ['end date must be after start date']

    assert FactoryBot.build_stubbed(:warranty, warranty_end_date: 49.days.ago).valid?
  end

  test 'Cannot save warranty without necessary params' do
    empty_warranty = FactoryBot.build(
      :warranty,
      warranty_name: '',
      warranty_company: '',
      warranty_start_date: nil,
      user: nil
    )
    expected_errors = {
      user: ['must exist'],
      warranty_name: ['can\'t be blank', 'is too short (minimum is 2 characters)'],
      warranty_company: ['can\'t be blank', 'is too short (minimum is 2 characters)'],
      warranty_start_date: ['is not a valid date']
    }

    assert_raises(ActiveRecord::RecordInvalid) do
      empty_warranty.save!
    end
    assert_equal expected_errors, empty_warranty.errors.messages
  end

  test 'don\'t allow too long extra_info' do
    invalid_warranty = FactoryBot.build(:warranty, extra_info: 'A' * 251)

    assert_raises(ActiveRecord::RecordInvalid) do
      invalid_warranty.save!
    end
    assert_equal invalid_warranty.errors.messages[:extra_info], ['is too long (maximum is 250 characters)']
  end

  test 'Save valid warranty' do
    total = Warranty.count

    assert FactoryBot.create(:warranty)

    assert_equal total + 1, Warranty.count
  end

  test 'Cannot update invalid warranty' do
    too_short_warranty = FactoryBot.create(:warranty)
    no_start_warranty = FactoryBot.create(:warranty)
    long_info_warranty = FactoryBot.create(:warranty)
    bad_end_date_warranty = FactoryBot.create(:warranty)

    assert_raises(ActiveRecord::RecordInvalid) do
      too_short_warranty.update!(warranty_name: 'A', warranty_company: 'B')
    end
    assert_equal too_short_warranty.errors.messages.count, 2

    assert_raises(ActiveRecord::RecordInvalid) do
      no_start_warranty.update!(warranty_start_date: nil)
    end
    assert_equal no_start_warranty.errors.messages.count, 1

    assert_raises(ActiveRecord::RecordInvalid) do
      long_info_warranty.update!(extra_info: 'A' * 251)
    end
    assert_equal long_info_warranty.errors.messages.count, 1

    assert_raises(ActiveRecord::RecordInvalid) do
      bad_end_date_warranty.update!(extra_info: 'A' * 251)
    end
    assert_equal bad_end_date_warranty.errors.messages.count, 1
  end

  test 'Update valid warranty' do
    warranty = FactoryBot.create(:warranty)

    assert warranty.update!(warranty_name: 'Malibu Barbie', warranty_company: 'Hasbro')
  end

  test 'destroy warranty' do
    warranty = FactoryBot.create(:warranty)
    total = Warranty.count

    assert warranty.destroy
    assert_equal total - 1, Warranty.count
  end
end
