require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'

class PatronTest < Minitest::Test
  def test_it_exists
    patron_1 = Patron.new("Bob", 20)

    assert_instance_of Patron, patron_1
  end

  def test_attributes
    patron_1 = Patron.new("Bob", 20)

    assert_equal 'Bob', patron_1.name
    assert_equal 20, patron_1.spending_money
    assert_equal [], patron_1.interests
  end

  def test_it_has_interests
    patron_1 = Patron.new("Bob", 20)
    exhibit1 = Exhibit.new({name: "Gems and Minerals", cost: 0})
    exhibit2 = Exhibit.new({name: "Dead Sea Scrolls", cost: 0})

    patron_1.add_interest(exhibit2.name)
    patron_1.add_interest(exhibit1.name)

    assert_equal ["Dead Sea Scrolls", "Gems and Minerals"], patron_1.interests
  end
end