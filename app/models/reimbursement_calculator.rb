class ReimbursementCalculator
    def self.execute(reimbursement)
        reimbursement_hash = reimbursement.attributes
        cleaned_up_reimbursement = clean_up_reimbursement(reimbursement_hash)
        # OPTIMIZE This is where I should reach for other POROs instead of messing with an array of hashes.
        formatted_reimbursement = format_reimbursement(cleaned_up_reimbursement)
        non_duplicate_reimbursement = remove_reimbursement_duplicate_dates(formatted_reimbursement)
        sorted_reimbursement = non_duplicate_reimbursement.sort.to_h
       # TODO Figure out if there are gaps in the dates & then assign the dates as "full" or "travel" days.
       # TODO Assign the $ values for each day type & cost city type.
       # TODO Do the actual math that calculates the total.
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

        project_set_array = []

        date_range.each do |date|
            project_set_array << { date => cost_city }
        end

        return project_set_array
    end

    def self.format_reimbursement(cleaned_up_reimbursement)
        project_set_array = []
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

            project_set_array << create_project_date_range(project_hash)

            i += 1
        end

        return project_set_array.flatten.uniq #calling .uniq here so we can preemptively remove the exact duplicates.
    end

    def self.remove_reimbursement_duplicate_dates(formatted_reimbursement)
        formatted_reimbursement.inject({}) do |new_hash, date_hash|
            key = date_hash.keys.first

            if !new_hash[key]
                new_hash[key] = date_hash[key]
            elsif new_hash[key] == 'low'
                new_hash[key] = date_hash[key]
            end
            
            new_hash
        end
    end
end