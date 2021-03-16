defmodule Number do
  @doc """
  naive primality checking algorithm with simple 6k ± 1 optimization
  """
  def prime?(number) when is_integer(number) do
    cond do
      number <= 3 ->
        number > 1

      rem(number, 2) == 0 or rem(number, 3) == 0 ->
        false

      true ->
        i = 5
        power_check(i, number)
    end
  end

  defp power_check(i, number) when i * i > number do
    true
  end

  defp power_check(i, number) do
    cond do
      rem(number, i) == 0 or rem(number, i + 2) == 0 ->
        false

      true ->
        power_check(i + 6, number)
    end
  end
end
