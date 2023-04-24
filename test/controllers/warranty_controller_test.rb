# frozen_string_literal: true

require 'test_helper'

# Warranty controller tests
class WarrantyControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:fox)
    sign_in @user

    @warranty = FactoryBot.create(:warranty, user: @user)
  end

  test 'Warranty Index' do
    FactoryBot.create(:warranty, warranty_name: 'Malibu Barbie', warranty_company: 'Hasbro', user: @user)
    FactoryBot.create(:warranty, warranty_name: 'White Chair', warranty_company: 'Living Spaces', user: @user)

    get warranty_index_path
    assert_select 'h1', 'Warranty Index'
    assert_select 'a', 'Malibu Barbie'
    assert_select 'a', 'White Chair'
  end

  test 'Index displays only warranties associated with user' do
    admin = FactoryBot.create(:user)
    admin_warranty = FactoryBot.create(:warranty, user: admin)

    get warranty_index_path
    assert_select admin_warranty.warranty_name, false
  end

  test 'Index will not display any warranties table if there are no warranties' do
    # This scenario is typically for a new user who hasn't yet added any warranties
    new_user = FactoryBot.create(:user)
    sign_in new_user

    get warranty_index_path
    assert_select 'Current Warranties', false
    assert_select 'Expired Warranties', false
  end

  test 'Index will not display expired warranties table if there are no expired warranties' do
    get warranty_index_path
    assert_select 'Expired Warranties', false
  end

  test 'Index will display expired warranties if some exist' do
    FactoryBot.create(:warranty, user: @user, expired: true)

    get warranty_index_path
    assert_select 'caption', 'Current Warranties'
    assert_select 'caption', 'Expired Warranties'
  end

  test 'Show warranty' do
    show_warranty = FactoryBot.create(:warranty, user: @user, extra_info: 'something', warranty_end_date: 1.day.ago)

    get warranty_path(show_warranty)
    assert_response :success
    assert_match show_warranty.warranty_name, response.body
    assert_match show_warranty.warranty_company, response.body
    assert_match show_warranty.extra_info, response.body
    assert_match show_warranty.warranty_start_date.to_s, response.body
    assert_match show_warranty.warranty_end_date.to_s, response.body
  end

  test 'Show warranty does not display extra info if field is empty' do
    no_extra_info = FactoryBot.create(:warranty, user: @user, warranty_end_date: 1.day.ago)

    get warranty_path(no_extra_info)
    assert_response :success
    assert_no_match 'Extra Info', response.body
  end

  test 'Show warranty displays "Lifetime" if warranty_end_date is empty' do
    no_end_date = FactoryBot.create(:warranty, user: @user, extra_info: 'something')

    get warranty_path(no_end_date)
    assert_response :success
    assert_match 'Lifetime', response.body
  end

  test 'Display Index if navigating to other user\'s warranty' do
    admin = FactoryBot.create(:user)
    admin_warranty = FactoryBot.create(:warranty, user: admin)

    get warranty_path(admin_warranty)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Warranty Index'
  end

  test 'Create warranty' do
    params = FactoryBot.attributes_for(:warranty, warranty_name: 'Gaming Chair', warranty_company: 'Razr')

    post warranty_index_path, params: { warranty: params }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match 'Gaming Chair', response.body
    assert_match 'Razr', response.body
    assert_flash_message 'Warranty created successfully!', flash[:notice]
  end

  test 'Error during create warranty' do
    invalid_params = FactoryBot.attributes_for(:warranty, warranty_name: nil)

    post warranty_index_path, params: { warranty: invalid_params }
    assert_response :unprocessable_entity
  end

  test 'Edit warranty' do
    get edit_warranty_path(@warranty)
    assert_response :success
    assert_select 'h1', "Edit #{@warranty.warranty_name} Warranty"
  end

  test 'Update warranty' do
    params = FactoryBot.attributes_for(:warranty, warranty_name: 'robin-hood')

    put warranty_path(@warranty), params: { warranty: params }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match 'robin-hood', response.body
    assert_flash_message 'Warranty updated successfully!', flash[:warning]
  end

  test 'Error during update warranty' do
    invalid_name_params = FactoryBot.attributes_for(:warranty, warranty_name: 'A')
    invalid_start_params = FactoryBot.attributes_for(:warranty, warranty_start_date: nil)

    put warranty_path(@warranty), params: { warranty: invalid_name_params }
    assert_response :unprocessable_entity

    put warranty_path(@warranty), params: { warranty: invalid_start_params }
    assert_response :unprocessable_entity
  end

  test 'Destroy warranty' do
    delete warranty_path(@warranty)
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_flash_message 'Warranty destroyed!', flash[:danger]

    assert_raises(ActiveRecord::RecordNotFound) do
      assert_not Warranty.find(id: @warranty.id)
    end
  end
end
