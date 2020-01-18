class MembersController < ApplicationController
  class MailingListNoLifetime < List
    def members
      Member.mailing_list_no_lifetime
    end
  end
end
