# frozen_string_literal:true

# Handles actions on Warranty Model
class WarrantyController < ApplicationController
  attr_accessor :warranty_name, :warranty_company

  def index
    @warranties = Warranty.where(user_id: loaded_user)
  end

  def show
    @warranty = Warranty.find(params[:id])
  end

  def new
    @warranty = Warranty.new
  end

  def create
    params = warranty_params
    # params[:user_id] = loaded_user
    @warranty = Warranty.new(params)

    if @warranty.save
      redirect_to @warranty
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

    @warranty = Warranty.find(params[:id])
  end

  def update
    @warranty = Warranty.find(params[:id])

    if @warranty.update(warranty_params)
      redirect_to @warranty
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @warranty = Warranty.find(params[:id])
    @warranty.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def warranty_params
    params.require(:warranty).permit(
      :warranty_name,
      :warranty_company,
      :extra_info,
      :warranty_start_date,
      :warranty_end_date,
      :user_id
    )
  end

  def loaded_user
    @loaded_user ||= current_user.id
  end
end
