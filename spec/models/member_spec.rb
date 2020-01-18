require 'rails_helper'

describe Member do
  describe ".search" do
    let!(:member) do
      Member.create(first_name: "Nikolai", last_name: "LastName", email: "nikolai@example.com", over_18: true)
    end
    let!(:someone_else) do
      Member.create(first_name: "Other", last_name: "Person", email: "other@example.com", over_18: true)
    end

    it "finds by names" do
      expect(described_class.search("nikola").to_a).to eq([member])
      expect(described_class.search("nikolai notlastname")).to eq([])
      expect(described_class.search("nikolai last")).to eq([member])
    end

    it "finds by email" do
      expect(described_class.search("nikolai@ex")).to eq([member])
    end

    it "finds by no" do
      expect(described_class.search("#{member.no}")).to eq([member])
    end
  end
  it 'has a full name' do
    member = Member.new(first_name: 'Russell', last_name: 'Dunphy')
    expect(member.full_name).to eq 'Russell Dunphy'
  end

  it 'can return its full address as an array' do
    member = Member.new(address_one: '123 Street', address_two: 'Southport', postcode: 'AB1 234')
    expect(member.address).to eq [
      '123 Street',
      'Southport',
      'AB1 234'
    ]
  end

  let (:member) { Member.new }

  it 'starts off as a pending member' do
    expect(member).to be_pending
    expect(member).to_not be_expired
    expect(member).to_not be_current
  end

  it 'can be completed' do
    member.complete
    expect(member).to_be be_pending
    expect(member).to be_current
    expect(member).to_be be_expired
  end

  it 'is a current member immediately once renewed' do
    member.renew
    expect(member).to be_current
    expect(member).to_be be_expired
  end

  it 'becomes an expired member after the end of the calendar year' do
    member.renew
    Date.stub(today: Date.today + 1.year)
    expect(member).to be_expired
    expect(member).to_be be_current
  end

  it 'should not expire if lifetime member' do
    member.renew
    member.lifetime_membership = true
    Date.stub(today: Date.today + 15.year)
    expect(member).to be_current
    expect(member).to_not be_expired
  end
end
