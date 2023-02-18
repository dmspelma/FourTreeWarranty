class WarrantyController < ApplicationController
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

  private

  def warranty_params
    params.require(:warranty).permit(:warranty_name, :warranty_company, :warranty_start_date, :warranty_end_date)
  end
end
