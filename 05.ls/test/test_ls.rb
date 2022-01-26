require 'minitest/autorun'

class LsTest < Minitest::Test
  def test_ls_without_option
    expected = 'hoge'
    assert_equal(expected, 'hoge')
  end
end
