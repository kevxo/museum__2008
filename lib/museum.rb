class Museum
  attr_reader :name, :exhibits, :patrons
  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    @exhibits.find_all do |exhibit|
      patron.interests.include?(exhibit.name)
    end.reverse
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    results = {}
    @exhibits.each do |exhibit|
      @patrons.each do |patron|
        results[exhibit] ||= []
        results[exhibit] << patron if
        patron.interests.include?(exhibit.name)
      end
    end
    results
  end

  def ticket_lottery_contestants(exhibit)
    patrons = patrons_by_exhibit_interest[exhibit]
    patrons.find_all do |patron|
      patron.spending_money < exhibit.cost
    end
  end
end
