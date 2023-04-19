# frozen_string_literal:true

# Handles actions on Warranty Model
class WarrantyController < ApplicationController
  attr_accessor :warranty_name, :warranty_company

  def index
    @warranties = Warranty.all
  end

  def show
    @warranty = Warranty.find(params[:id])
  end

  def new
    @warranty = Warranty.new
  end

  def create
    @warranty = Warranty.new(warranty_params)

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
      :warranty_end_date
    )
  end
end
