# frozen_string_literal:true

# Handles actions on Warranty Model
class WarrantyController < ApplicationController
  attr_accessor :warranty_name, :warranty_company

  def index
    @warranties = Warranty.where(user_id: loaded_user).where.not(expired: true)
    @expired_warranties = Warranty.where(user_id: loaded_user, expired: true)
  end

  def show
    @warranty = Warranty.find(params[:id])

    if @warranty.user_id == loaded_user
      @warranty
    else
      redirect_to warranty_index_path
    end
  end

  def new
    @warranty = Warranty.new
  end

  def edit
    @warranty = Warranty.find(params[:id])
  end

  def create
    @warranty = Warranty.new(full_params)

    if @warranty.save
      flash[:notice] = 'Warranty created successfully!'
      redirect_to @warranty
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @warranty = Warranty.find(params[:id])

    if @warranty.update(full_params)
      flash[:warning] = 'Warranty updated successfully!'
      redirect_to @warranty
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @warranty = Warranty.find(params[:id])
    @warranty.destroy

    flash[:danger] = 'Warranty destroyed!'
    redirect_to root_path, status: :see_other
  end

  private

  def warranty_params
    params.require(:warranty).permit(
      :warranty_name,
      :warranty_company,
      :extra_info,
      :warranty_start_date,
      :warranty_end_date
    )
  end

  def full_params
    full_params = warranty_params
    full_params[:user_id] = loaded_user
    full_params
  end

  def loaded_user
    @loaded_user ||= current_user.id
  end
end
