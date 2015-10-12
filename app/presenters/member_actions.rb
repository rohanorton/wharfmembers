class MemberActions

  def initialize(template, member)
    @template = template
    @member = member
  end

  def render
    case member
    when ~:pending? then pending
    when ~:current? then current
    else expired end
  end

  private

  def pending
    # no need for any actions
  end

  def current
    # no need for any actions
  end

  def expired
    template.link_to "Renew Membership", template.renew_member_path(id: member.no), class: 'btn'
  end

  attr_reader :template, :member

end
