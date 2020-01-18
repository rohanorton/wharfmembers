class Member

  module Adapter
    module CSV
      extend self

      def adapt(members)
        ::CSV.generate(write_headers: true, headers: ["Email", "Name", "Currently a member",  "Lifetimer"])  do |csv|
          members.each { |member| csv << [member.email, member.full_name, member.current?, member.lifetime_membership] }
        end
      end

    end
  end
end
