class ReimbursementsController < ApplicationController
    def new
    end

    def create
        @reimbursement = Reimbursement.new(reimbursement_params)
        @reimbursement.save

        redirect_to @reimbursement
    end

    def show
        @reimbursement = Reimbursement.find_by_id(params[:id])
    end

    private

    def reimbursement_params
        params.permit(:cost_city_1, :start_date_1, :end_date_1, :cost_city_2, :start_date_2, :end_date_2, :cost_city_3, :start_date_3, :end_date_3, :cost_city_4, :start_date_4, :end_date_4)
    end
end

    