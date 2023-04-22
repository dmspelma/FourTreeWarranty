# frozen_string_literal: true

require 'test_helper'

# Warranty controller tests
class WarrantyControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    user = users(:fox)
    sign_in user

    @valid_params = {
      warranty_name: 'iPhone X',
      warranty_company: 'Apple',
      warranty_start_date: Date.current,
      user_id: user.id
    }
    @warranty = Warranty.create!(@valid_params)
  end

  test 'Warranty Index' do
    barbie = @valid_params.dup
    barbie[:warranty_name] = 'Malibu Barbie'
    barbie[:warranty_company] = 'Hasbro'

    chair = @valid_params.dup
    chair[:warranty_name] = 'White Chair'
    chair[:warranty_company] = 'Living Spaces'

    Warranty.create!(barbie)
    Warranty.create!(chair)

    get warranty_index_path
    assert_select 'robinhood', false
    assert_select 'a', 'Malibu Barbie'
    assert_select 'a', 'White Chair'
  end

  test 'Show warranty' do
    get warranty_path(@warranty)
    assert_response :success
    assert_select 'p', @warranty.warranty_name
    assert_select 'p', @warranty.warranty_company
  end

  test 'Create warranty' do
    params = @valid_params.dup
    params[:warranty_name] = 'Gaming Chair'
    params[:warranty_company] = 'Razr'

    post warranty_index_path, params: { warranty: params }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'p', 'Gaming Chair'
    assert_select 'p', 'Razr'
  end

  test 'Error during create warranty' do
    admin = User.new(email: 'admin@example.com', password: 'test1234')

    no_name_params = {
      warranty_name: 'robinhood'
    }
    invalid_user_id = {
      user_id: admin.id
    }

    post warranty_index_path, params: { warranty: no_name_params }
    assert_response :unprocessable_entity

    post warranty_index_path, params: { warranty: invalid_user_id }
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

    invalid_start = {
      warranty_start_date: nil
    }

    put warranty_path(@warranty), params: { warranty: invalid_name }
    assert_response :unprocessable_entity

    put warranty_path(@warranty), params: { warranty: invalid_start }
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
