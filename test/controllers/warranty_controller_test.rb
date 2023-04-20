# frozen_string_literal: true

require 'test_helper'

# Warranty controller tests
class WarrantyControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @warranty = Warranty.create!(warranty_name: 'iPhone X', warranty_company: 'Apple')

    sign_in users(:fox)
  end

  test 'Warranty Index' do
    Warranty.create!(warranty_name: 'Malibu Barbie', warranty_company: 'Hasbro')
    Warranty.create!(warranty_name: 'White Chair', warranty_company: 'Living Spaces')

    get warranty_index_path
    assert_select 'a', 'robinhood'
    assert_select 'a', 'Malibu Barbie'
    assert_select 'a', 'White Chair'
  end

  test 'Show warranty' do
    get warranty_path(Warranty.first.id)
    assert_response :success
    assert_select 'p', Warranty.first.warranty_name
    assert_select 'p', Warranty.first.warranty_company
  end

  test 'Create warranty' do
    params = {
      warranty_name: 'Gaming Chair',
      warranty_company: 'Razr'
    }

    post warranty_index_path, params: { warranty: params }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'Gaming Chair'
    assert_select 'p', 'Razr'
  end

  test 'Error during create warranty' do
    no_name_params = {
      warranty_name: 'robinhood'
    }
    no_company_params = {
      warranty_company: 'thisfoxcodes'
    }

    post warranty_index_path, params: { warranty: no_name_params }
    assert_response :unprocessable_entity

    post warranty_index_path, params: { warranty: no_company_params }
    assert_response :unprocessable_entity
  end

  test 'Edit warranty' do
    get edit_warranty_path(@warranty)
    assert_response :success
    assert_select 'h1', "Edit #{@warranty.warranty_name} Warranty"
  end

  test 'Update warranty' do
    params = {
      warranty_name: 'robin-hood'
    }

    put warranty_path(@warranty), params: { warranty: params }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'robin-hood'
  end

  test 'Error during update warranty' do
    invalid_name = {
      warranty_name: 'A'
    }

    invalid_company = {
      warranty_company: 'B'
    }

    put warranty_path(@warranty), params: { warranty: invalid_name }
    assert_response :unprocessable_entity

    put warranty_path(@warranty), params: { warranty: invalid_company }
    assert_response :unprocessable_entity
  end

  test 'Destroy warranty' do
    delete warranty_path(@warranty)
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_raises(ActiveRecord::RecordNotFound) do
      assert_not Warranty.find(id: @warranty.id)
    end
  end
end
