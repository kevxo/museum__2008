class Museum
  attr_reader :name, :exhibits
  def initialize(name)
    @name = name
    @exhibits = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    exhibit_interest = []
    patron.interests.each do |interest|
      @exhibits.each do |exhibit|
        if interest == exhibit.name
          exhibit_interest << exhibit
        end
      end
    end
    exhibit_interest
  end
end