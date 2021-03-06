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

  def draw_lottery_winner(exhibit)
    winner = ticket_lottery_contestants(exhibit).sample
    winner.name if !winner.nil?
  end

  def announce_lottery_winner(exhibit)
    winner_name = draw_lottery_winner(exhibit)
    if winner_name
      "#{winner_name} has won the the #{exhibit.name} exhibit lottery"
    else
      "No winners for this lottery"
    end
  end
end
