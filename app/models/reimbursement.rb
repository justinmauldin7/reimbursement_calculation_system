class Reimbursement < ApplicationRecord
    def total
        ReimbursementCalculator.execute(self)
    end
end
