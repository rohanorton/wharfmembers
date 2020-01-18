class MembersController < ApplicationController
  extend Fendhal::Controller

  skip_before_filter :authenticate_user!, only: [:join, :register]

  defines :index, :current, :pending, :expired, :lifetime, :mailing_list, :mailing_list_expired, :mailing_list_no_lifetime

  def show
    @member = Member.find_by(no: params[:id])
  end

  def new
    @member = Member.new
  end

  def register
    @member = Member.new
    render layout: false
  end

  def edit
    puts "=== #{params[:id]}"
    @member = Member.find_by(no: params[:id])
  end

  def renew
    @member = Member.find_by(no: params[:id])
    @member.renew
    redirect_to member_path(id: @member.no)
  end

  def bulk_action
    if params.fetch(:ids, []).any?
      @members = Member.find(params[:ids])
      if params['delete-selected'].present?
        @members.each(&:destroy)
      elsif params['complete-selected'].present?
        @members.each(&:complete).each(&:save)
      elsif params['renew-selected'].present?
        @members.each(&:renew)
      end
    end
    redirect_to :back
  end

  def member_params
    params.require(:member).permit(:first_name,
                                   :last_name,
                                   :email,
                                   :email_allowed,
                                   :address_one,
                                   :address_two,
                                   :address_three,
                                   :postcode,
                                   :notes,
                                   :lifetime_membership)
  end

  def create
    if params[:member_existing_member]
      existing_create
    else
      new_create
    end
  end
  alias_method :join, :create

  def update
    @member = Member.find_by(no: params[:id])
    if @member.update_attributes(member_params)
      redirect_to member_path(id: @member.no), notice: 'Member was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @member = Member.find_by(no: params[:id])
    @member.destroy
    redirect_to members_url
  end

  private

  def existing_create
    begin
      @member = Member.find_by(email: member_params[:email], first_name_lowercase: member_params[:first_name].try(:downcase), last_name_lowercase: member_params[:last_name].try(:downcase))
    rescue  Mongoid::Errors::DocumentNotFound
      return render text: "Sorry, we could not find your details matching your name and email. Please try again or register as a new member. Thanks"
    end
    @member.update!(member_params)
    @member.renew
    render text: "Thank you #{@member.full_name} [Member number #{@member.no}], please speak to a member of staff next time you're in to finalise your renewal"
  end

  def new_create
    @member = Member.new(member_params)
    if @member.save
      if params[:register]
        render text: "Thanks for registering, #{@member.full_name} [Member number #{@member.no}]."
      else
        redirect_to member_path(id: @member.no), notice: 'Member was successfully created.'
      end
    else
      if params[:register]
        render action: "register", layout: false
      else
        render action: "new"
      end
    end
  end
end
