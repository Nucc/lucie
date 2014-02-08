require "test_helper"

class CommandLineSlicerTest < MiniTest::Unit::TestCase

  include Lucie::Core

  def test_empty
    assert_equal [], CommandLineSlicer.new("").to_a
  end

  def test_one_word
    assert_equal ["word"], CommandLineSlicer.new("word").to_a
  end

  def test_more_words_with_spaces
    assert_equal ["first", "second"], CommandLineSlicer.new("first second").to_a
  end

  def test_neutral_space
    assert_equal ["first second"], CommandLineSlicer.new("first\\ second").to_a
  end

  def test_neutral_element_on_another_neutral
    assert_equal ["first\\", "second"], CommandLineSlicer.new("first\\\\ second").to_a
  end

  def test_neutral_element_on_another_neutral_between_quotation
    assert_equal ["first\\ second"], CommandLineSlicer.new('"first\\\\ second"').to_a
  end

  def test_quotation_marks
    assert_equal ["first", "second third"], CommandLineSlicer.new('first "second third"').to_a
    assert_equal ["first", "second third"], CommandLineSlicer.new("first 'second third'").to_a
  end
end