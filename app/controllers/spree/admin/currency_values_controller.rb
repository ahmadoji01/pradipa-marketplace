module Spree
    module Admin
        class CurrencyValuesController < Spree::Admin::BaseController
            before_action :set_currency_value, only: %i[ show edit update destroy ]

            def index
                params[:q] ||= {}

                @search = CurrencyValue.accessible_by(current_ability, :index).ransack(params[:q])
                @search.sorts = 'currency_from desc' if @search.sorts.empty?
                @currency_values = @search.result.
                    page(params[:page]).
                    per(params[:per_page] || Spree::Config[:orders_per_page])
            end
        
            # GET /spree/blogs/new
            def new
                @currency_value = CurrencyValue.new
            end
        
            # GET /spree/blogs/1/edit
            def edit
                @currency_value = CurrencyValue.find(params[:id])
            end
        
            # POST /spree/blogs or /spree/blogs.json
            def create
                @currency_value = CurrencyValue.new(currency_value_params)
                
                respond_to do |format|
                    if @currency_value.save
                        format.html { redirect_to main_app.admin_currency_values_path, notice: "Currency value was successfully created." }
                        format.json { render :show, status: :created, location: main_app.admin_currency_values_path }
                    else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
                    end
                end
            end
        
            # PATCH/PUT /spree/blogs/1 or /spree/blogs/1.json
            def update
                respond_to do |format|
                    if @currency_value.update(currency_value_params)
                        format.html { redirect_to main_app.edit_admin_currency_value_path(@currency_value), notice: "Currency value was successfully updated." }
                        format.json { render :show, status: :ok, location: main_app.edit_admin_currency_value_path(@currency_value) }
                    else
                        format.html { render :edit, status: :unprocessable_entity }
                        format.json { render json: @spree_blog.errors, status: :unprocessable_entity }
                    end
                end
            end
        
            # DELETE /spree/blogs/1 or /spree/blogs/1.json
            def destroy
                @currency_value.destroy
                respond_to do |format|
                    format.html { redirect_to main_app.admin_currency_values_path, notice: "Currency value was successfully destroyed." }
                    format.json { head :no_content }
                end
            end
        
            private        
                # Use callbacks to share common setup or constraints between actions.
                def set_currency_value
                    @currency_value = CurrencyValue.find(params[:id])
                end
        
                # Only allow a list of trusted parameters through.
                def currency_value_params
                    params.fetch(:currency_value, {}).permit(:currency_from, :currency_to, :value)
                end
        end
    end
end
  