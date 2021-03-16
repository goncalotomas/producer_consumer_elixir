defmodule Producer do
  use GenStage

  def start_link(primes) do
    GenStage.start_link(Producer, primes)
  end

  def init(primes) do
    {:producer, {1_000_000_000_000, primes}}
  end

  def handle_demand(demand, {sequence, primes} = state) when demand > 0 do
    numbers =
      for number <- sequence..(sequence + demand) do
        cond do
          # 2% chance to replace number by a known prime number
          # this is done to test the consumers' prime number collection in state
          :rand.uniform(100) <= 2 ->
            Enum.at(primes, :rand.uniform(length(primes)) - 1)

          true ->
            number
        end
      end

    {:noreply, numbers, {sequence + demand, primes}}
  end
end
