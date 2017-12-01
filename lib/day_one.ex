defmodule Adventofcode.DayOne do
  @moduledoc"""

  Advent of Code Day 1

  The captcha requires you to review a sequence of digits (your puzzle input)
  and find the sum of all digits that match the next digit in the list. The list
  is circular, so the digit after the last digit is the first digit in the list.

  For example:
    - 1122 produces a sum of 3 (1 + 2) because the first digit (1) matches the
           second digit and the third digit (2) matches the fourth digit.
    - 1111 produces 4 because each digit (all 1) matches the next.
    - 1234 produces 0 because no digit matches the next.
    - 91212129 produces 9 because the only digit that matches the next one is
               the last digit, 9.
  """

  # PART 1
  def slice_string(str) do
    str |> String.slice(1, (str |> String.length()) - 1)
  end
  def check_first_and_last(str) do
    last_index = (str |> String.length()) - 1 # Getting last digit
    first_char = str |> String.at(0)
    last_char = str |> String.at(last_index)
    with true <- first_char == last_char do
      total = first_char |> Integer.parse() |> elem(0)
      {str, total}
    else
      _ -> {str, 0}
    end
  end

  def calculate_sum(a, b, str, total) when a != b do
    calculate_sum({str |> slice_string(), total})
  end

  def calculate_sum(a, b, str, total) when a == b do
    calculate_sum({str |> slice_string(), total + (a |> Integer.parse() |> elem(0))})
  end

  def calculate_sum({"", total}) do # THE END
    total
  end

  def calculate_sum({str, total} = _params) do
    calculate_sum(str |> String.at(0), str |> String.at(1), str, total)
  end

  def process(str) do
      str
      |> check_first_and_last()
      |> calculate_sum()
  end



  @doc"""
   Now, instead of considering the next digit, it wants you to consider the digit
   halfway around the circular list. That is, if your list contains 10 items,
   only include a digit in your sum if the digit 10/2 = 5 steps forward matches
   it. Fortunately, your list has an even number of elements.


   For example:

    - 1212 produces 6: the list contains 4 items, and all four digits match the digit 2 items ahead.
    - 1221 produces 0, because every comparison is between a 1 and a 2.
    - 123425 produces 4, because both 2s match each other, but no other digit has a match.
    - 123123 produces 12.
    - 12131415 produces 4.
  """
  ## PART II
  def process_half(str) do
    {str, 0, trunc((str |> String.length()) / 2) }
    |> calculate_sum_half()
  end

  def calculate_sum_half({"", total, _}) do # THE END
    total
  end

  def calculate_sum_half(a, b, str, mid_point, total) when a != b do
    calculate_sum_half({str |> slice_string(), total, mid_point})
  end

  def calculate_sum_half(a, b, str, mid_point, total) when a == b do
    sum = (a |> Integer.parse() |> elem(0)) + (b |> Integer.parse() |> elem(0))
    new_string = str |> slice_string()
    calculate_sum_half({new_string, total + sum, mid_point})
  end

  def calculate_sum_half({str, total, mid_point} = params) do
    calculate_sum_half(str |> String.at(0), str |> String.at(mid_point), str, mid_point, total)
  end
end
