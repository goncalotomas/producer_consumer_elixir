defmodule Consumer do
  use GenStage

  def start_link(primes \\ []) do
    GenStage.start_link(Consumer, primes)
  end

  def init(primes) do
    {:consumer, primes}
  end

  def handle_events([], _from, primes) do
    {:noreply, [], primes}
  end

  def handle_events([number | rest], from, primes) do
    cond do
      number in primes ->
        IO.puts("#{number} is prime, fetched from state")
        handle_events(rest, from, [number | primes])

      Number.prime?(number) ->
        IO.puts("#{number} is prime, calculated and added to state")
        handle_events(rest, from, [number | primes])

      true ->
        handle_events(rest, from, primes)
    end
  end
end
