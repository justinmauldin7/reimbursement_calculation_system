class ReimbursementCalculator
    def self.execute(reimbursement)
        reimbursement_hash = reimbursement.attributes
        formatted_reimbursement = format_reimbursement(reimbursement_hash)
    end

    private

    def self.format_reimbursement(reimbursement_hash)
        # Remove the fields we do not care about
        reimbursement_hash.delete('id')
        reimbursement_hash.delete('created_at')
        reimbursement_hash.delete('updated_at')

        reimbursement_hash.map do |key, value|
            # make sure that every value is a string for the below logic 
            # since we deal with other data types.
            value = value.to_s

            if value.nil? || value.empty?
                reimbursement_hash.delete(key)
            end
        end

        return reimbursement_hash
    end
end