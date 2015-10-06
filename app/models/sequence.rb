class Sequence
  include Mongoid::Document

  field :value

  def self.next(name)
    where(name: name).
      find_one_and_replace({ "$inc" => { value: 1 }}, new: true, upsert: true).value
  end

end
