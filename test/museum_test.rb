require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'
require './lib/museum'
require 'mocha/minitest'

class MuseumTest < Minitest::Test
  def test_it_exists
    dmns = Museum.new('Denver Museum of Nature and Science')

    assert_instance_of Museum, dmns
  end

  def test_attributes
    dmns = Museum.new('Denver Museum of Nature and Science')

    assert_equal 'Denver Museum of Nature and Science', dmns.name
    assert_equal [], dmns.exhibits
  end

  def test_add_exhibits
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [gems_and_minerals, dead_sea_scrolls, imax], dmns.exhibits
  end

  def test_adds_recommend_exhibits
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    patron_1 = Patron.new('Bob', 20)
    patron_1.add_interest(dead_sea_scrolls.name)
    patron_1.add_interest(gems_and_minerals.name)

    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest(imax.name)

    assert_equal [dead_sea_scrolls, gems_and_minerals], dmns.recommend_exhibits(patron_1)
    assert_equal [imax], dmns.recommend_exhibits(patron_2)
  end

  def test_has_no_patrons
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [], dmns.patrons

    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    assert_equal [patron_1, patron_2, patron_3], dmns.patrons
  end

  def test_patrons_by_exhibit_interests

    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    expected = {
      gems_and_minerals => [patron_1],
      dead_sea_scrolls => [patron_1, patron_2, patron_3],
      imax => []
    }

    assert_equal expected, dmns.patrons_by_exhibit_interest
  end

  def test_ticket_lottery_contestant
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    assert_equal [patron_1, patron_3], dmns.ticket_lottery_contestants(dead_sea_scrolls)
  end

  def test_draw_lottery_winner
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    assert_includes ['Johnny', 'Bob'], dmns.draw_lottery_winner(dead_sea_scrolls)
    assert_nil dmns.draw_lottery_winner(gems_and_minerals)
  end

  def test_it_anounces_lottery_winner
    dmns = Museum.new('Denver Museum of Nature and Science')
    gems_and_minerals = Exhibit.new({ name: 'Gems and Minerals', cost: 0 })
    dead_sea_scrolls = Exhibit.new({ name: 'Dead Sea Scrolls', cost: 10 })
    imax = Exhibit.new({ name: 'IMAX', cost: 15 })

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    patron_1 = Patron.new('Bob', 0)
    patron_1.add_interest('Gems and Minerals')
    patron_1.add_interest('Dead Sea Scrolls')
    patron_2 = Patron.new('Sally', 20)
    patron_2.add_interest('Dead Sea Scrolls')
    patron_3 = Patron.new('Johnny', 5)
    patron_3.add_interest('Dead Sea Scrolls')

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    assert_equal 'No winners for this lottery', dmns.announce_lottery_winner(gems_and_minerals)
    dmns.stubs(:draw_lottery_winner).returns("Bob")

    assert_equal 'Bob has won the IMAX exhibit lottery', dmns.announce_lottery_winner(imax)
  end
end
