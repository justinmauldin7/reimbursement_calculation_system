class ReimbursementCalculator
    def self.execute(reimbursement)
        reimbursement_hash = reimbursement.attributes
        cleaned_up_reimbursement = clean_up_reimbursement(reimbursement_hash)
        formatted_reimbursement = format_reimbursement(cleaned_up_reimbursement)
        binding.pry
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

    def self.create_project_date_range(project_hash)
        cost_city = project_hash.values.first

        # We need to remove the cost_city hash becasue it is not needed.
        project_hash.delete(project_hash.keys.first)

        start_date = project_hash.values.first
        end_date = project_hash.values.last
        date_range = (start_date..end_date).to_a

        { "cost_city" => cost_city, "dates" => date_range }
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

            project_set_hash[i] = create_project_date_range(project_hash)

            i += 1
        end

        return project_set_hash
    end
end