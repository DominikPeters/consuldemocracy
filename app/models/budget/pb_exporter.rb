class Budget
    class PbExporter
      SEPARATOR = ";"
  
      def initialize(budget)
        @budget = budget
        validate_budget
      end
  
      def generate_pb_content
        [
          generate_meta_section,
          generate_projects_section,
          generate_votes_section
        ].compact.join("\n\n")
      end
  
      private
  
      def validate_budget
        raise ArgumentError, "Invalid Budget ID" unless @budget.is_a?(Budget)
        raise ArgumentError, "Budget is not published" unless @budget.published?
        # Add more validations if necessary
      end
  
      # Generate the META section
      def generate_meta_section
        meta_fields = {}
        meta_fields["description"] = @budget.description.presence || "unknown"
        meta_fields["num_projects"] = @budget.investments.count
        meta_fields["num_votes"] = @budget.ballots.count
        # meta_fields["budget"] = @budget.budget.present? ? @budget.budget.to_s : "unknown"
        meta_fields["vote_type"] = @budget.voting_style.present? ? @budget.voting_style : "unknown"
        meta_fields["date_begin"] = @budget.phases.order(:starts_at).first&.starts_at&.strftime("%d.%m.%Y") || @budget.phases.order(:starts_at).first&.starts_at&.year.to_s || "unknown"
        meta_fields["date_end"] = @budget.phases.order(:ends_at).last&.ends_at&.strftime("%d.%m.%Y") || @budget.phases.order(:ends_at).last&.ends_at&.year.to_s || "unknown"
  
        # Optional fields based on vote_type
        # if @budget.voting_style == "approval"
        #   meta_fields["min_length"] = @budget.min_length.present? ? @budget.min_length : 1
        #   meta_fields["max_length"] = @budget.max_length.present? ? @budget.max_length : @budget.investments.count
        #   meta_fields["min_sum_cost"] = @budget.min_sum_cost.present? ? @budget.min_sum_cost : 0
        #   meta_fields["max_sum_cost"] = @budget.max_sum_cost.present? ? @budget.max_sum_cost : "∞"
        # end
  
        meta_section = ["META"]
        meta_section << meta_fields.keys.join(SEPARATOR)
        meta_section << meta_fields.values.map(&:to_s).join(SEPARATOR)
  
        meta_section.join("\n")
      end
  
      # Generate the PROJECTS section
      def generate_projects_section
        return nil if @budget.investments.empty?
  
        projects_section = ["PROJECTS"]
  
        headers = %w[
          project_id
          cost
          votes
          score
          name
          category
          target
          selected
          district
          neighborhood
          description
          proposer
          latitude
          longitude
        ]
  
        projects_section << headers.join(SEPARATOR)
  
        @budget.investments.find_each do |investment|
          row = []
          row << (investment.id.present? ? investment.id.to_s : "unknown")
          row << (investment.price.present? ? investment.price.to_s : "unknown")
          row << (investment.title.present? ? investment.title : "unknown")
          row << (investment.selected.present? ? investment.selected.to_s : "unknown")
          row << (investment.description.present? ? investment.description.gsub(/[\r\n]+/, " ") : "unknown")
          row << (investment.author.present? ? investment.author.name : "unknown")
  
          projects_section << row.join(SEPARATOR)
        end
  
        projects_section.join("\n")
      end
  
      # Generate the VOTES section
      def generate_votes_section
        return nil unless @budget.voting_style.present? && @budget.ballots.any?
  
        votes_section = ["VOTES"]
  
        vote_type = @budget.voting_style
        headers = ["voter_id"]
  
        case vote_type
        when "approval"
          headers << "vote"
        else
          # Add other vote types if necessary
          headers << "vote"
        end
  
        headers << "voting_method"
        headers << "district"
  
        votes_section << headers.join(SEPARATOR)
  
        @budget.ballots.find_each do |ballot|
          row = []
          row << (ballot.user.present? ? ballot.user.id.to_s : "unknown")
  
          case vote_type
          when "approval"
            approved_projects = ballot.lines.pluck(:investment_id).join(",")
            row << (approved_projects.present? ? approved_projects : "unknown")
          else
            row << "unknown" # Handle other vote types as needed
          end
  
          # row << (ballot.voting_method.present? ? ballot.voting_method : "unknown")
          # row << (ballot.user.district.present? ? ballot.user.district : "unknown")
  
          votes_section << row.join(SEPARATOR)
        end
  
        votes_section.join("\n")
      end
    end
  end
  