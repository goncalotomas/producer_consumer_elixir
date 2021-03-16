# Elixir Producer Consumer Example

This repository contains a simple application as an example of the producer consumer pattern implemented in Elixir using the [GenStage](https://hexdocs.pm/gen_stage/GenStage.html) library.

## Introduction

The [producer consumer pattern](https://en.wikipedia.org/wiki/Producer%E2%80%93consumer_problem) is a problem about generating data to process and processing it using multiple processes.

Implementing the producer consumer pattern in any language requires care for multiple edge cases and proper coordination between the communicating processes. The Elixir GenStage library provides most of this work, allowing developers to focus mainly on the application and not in implementing the pattern.

## The Application

This application is a simple but not simplistic application of the producer consumer pattern. In this application, the producer (we recommend using only 1) generates a list of numbers, which the consumers use to discover prime numbers.

The primality test algorithm is **not** the focus of this application and thus its efficiency as compared to other alternatives is not relevant here.

The producer's starting state includes a list of known prime numbers, and should include at least 1 number. When the produces generates numbers for consumers to work on, there is a 2% chance that known prime numbers are included instead of sequencial numbers.

The consumers, upon requesting a batch of numbers to process will iterate through each one and test for primality. If the number is prime, it will also be added to the state of the consumer process for quicker verification if the number is submitted for processing again. Additionally, the consumer prints to the console the prime number and how the number was verified: if through the primality test algorithm or through the state.

### Testing

Run `iex -S mix` from the root of this repository and use the following commands to test the application:

```elixir
primes = [1663,1667,1669,1693,1697,1699,1709,1721,1723,1733,1741,1747,1753,1759,1777,1783,1787,1789,1801,1811]
{:ok, producer} = Producer.start_link(primes)
{:ok, consumer1} = Consumer.start_link(primes)
{:ok, consumer2} = Consumer.start_link(primes)
GenStage.sync_subscribe(consumer1, to: producer)
GenStage.sync_subscribe(consumer2, to: producer)
```

After inputting these commands on the Elixir shell you should see the prime numbers being printed immediately. You can experiment further by adding more consumers and seeing how much of your CPU power you can use and take note of how frequently the known primes pop up in the terminal.

## Interest

Up to 90% of MapReduce jobs have small (<1GiB) of input[[1]](https://arxiv.org/abs/1208.4174), making single node implementations of Producer Consumer an interesting candidate for data processing. This percentage of workloads means that, in most cases, a simpler single-node approach to workload processing should be sufficient, and techniques like vertical scaling may be used to further extend the usability of this approach for larger jobs.

### References
[1] Chen, Y., Alspaugh, S. and Katz, R., 2012. Interactive analytical processing in big data systems: A cross-industry study of mapreduce workloads. arXiv preprint arXiv:1208.4174.
