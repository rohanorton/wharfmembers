class Member

  module Adapter
    module CSV
      extend self

      def adapt(members)
        ::CSV.generate do |csv|
          csv << [:email, :name]
          members.each { |member| csv << [member.email, member.full_name] }
        end
      end

    end
  end
end
