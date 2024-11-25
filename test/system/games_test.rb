require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "submitting a word not in grid shows error" do
    visit new_url
    page.execute_script("document.querySelector('input[name=\"letters\"]').value = 'ABCDEFGHIJ'")
    fill_in "word", with: "ZZZZZ"
    click_on "Play"
    assert_text "can't be built out of"
  end

  test "submitting invalid English word shows dictionary error" do
    visit new_url
    page.execute_script("document.querySelector('input[name=\"letters\"]').value = 'BCDFGHJKLM'")
    fill_in "word", with: "BBBBB"
    click_on "Play"
    assert_text "does not seem to be a valid English word"
  end

  test "submitting valid word shows congratulation" do
    visit new_url
    page.execute_script("document.querySelector('input[name=\"letters\"]').value = 'ABIRDSWING'")
    fill_in "word", with: "BIRD"
    click_on "Play"
    assert_text "Congratulations"
    assert_text "points reward"
  end
end
