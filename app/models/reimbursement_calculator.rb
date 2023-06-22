class ReimbursementCalculator
    def self.execute(reimbursement)
        reimbursement_hash = reimbursement.attributes
        cleaned_up_reimbursement = clean_up_reimbursement(reimbursement_hash)
        formatted_reimbursment = format_reimbursement(cleaned_up_reimbursement)
    end

    private

    def self.clean_up_reimbursement(reimbursement_hash)
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

    def self.format_reimbursement(cleaned_up_reimbursement)
        project_set_hash = {}
        i = 1
        # We divide by 3 here to calculate the "iteration_number" because that is 
        # how many key value pairs relate to each project.
        iteration_number = (cleaned_up_reimbursement.keys.count / 3) + 1
       
        while i < iteration_number  do
            project_hash = {}

            cleaned_up_reimbursement.each do |key, value|
                if key.include?(i.to_s)
                    project_hash[key] = value
                end
            end
            project_set_hash[i] = project_hash

            i += 1
        end

        return project_set_hash
    end
end