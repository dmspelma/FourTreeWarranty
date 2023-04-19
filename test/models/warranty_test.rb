# frozen_string_literal: true

require 'test_helper'

# Tests the warranty object
class WarrantyTest < ActiveSupport::TestCase
  # test 'Warranty initialized' do
  #   warranty = Warranty.new
  #   assert_nil warranty.warranty_name
  #   assert_nil warranty.warranty_company
  #   assert_not warranty.save
  # end

  setup do
    @params = {
      warranty_name: 'robinhood',
      warranty_company: 'thisfoxcodes'
    }
  end

  test 'Warranty name must be valid' do
    short_name = Warranty.new(warranty_name: 'A', warranty_company: 'Test')
    long_name = Warranty.new(warranty_name: 'A' * 51, warranty_company: 'Test')

    assert_not short_name.valid?
    assert_not long_name.valid?

    assert_not short_name.save
    assert_not long_name.save
  end

  test 'Cannot save missing warranty fields' do
    invalid_name = Warranty.new(warranty_company: 'foxy')
    invalid_company = Warranty.new(warranty_name: 'foxy')

    assert_not invalid_name.valid?
    assert_not invalid_company.valid?

    assert_not invalid_name.save
    assert_not invalid_company.save
  end

  test 'Save valid warranty' do
    total = Warranty.count

    assert Warranty.new(@params).save

    assert total + 1, Warranty.count
  end

  test 'Cannot create invalid warranty' do
    invalid_params = {
      warranty_name: 'A',
      warranty_company: 'B'
    }
    no_params = {
      warranty_name: '',
      warranty_company: ''
    }

    assert_raises(ActiveRecord::RecordInvalid) do
      Warranty.create!(invalid_params)
    end
    assert_raises(ActiveRecord::RecordInvalid) do
      Warranty.create!(no_params)
    end
  end

  test 'Create valid warranty' do
    total = Warranty.count

    assert Warranty.create!(@params)

    assert total + 1, Warranty.count
  end

  test 'Cannot update invalid warranty' do
    warranty = Warranty.create(@params)

    invalid_params = {
      warranty_name: 'A',
      warranty_company: 'B'
    }
    no_params = {
      warranty_name: '',
      warranty_company: ''
    }

    assert_raises(ActiveRecord::RecordInvalid) do
      warranty.update!(invalid_params)
    end
    assert_raises(ActiveRecord::RecordInvalid) do
      warranty.update!(no_params)
    end
  end

  test 'Update valid warranty' do
    warranty = Warranty.create!(@params)
    new_params = {
      warranty_name: 'Malibu Barbie',
      warranty_company: 'Hasbro'
    }

    assert warranty.update!(new_params)
  end

  test 'destroy warranty' do
    warranty = Warranty.create!(@params)
    total = Warranty.count

    assert warranty.destroy
    assert total - 1, Warranty.count
  end
end
