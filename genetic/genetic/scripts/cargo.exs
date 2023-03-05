# implementation of the Knapsack problem (10 items with the given weight and value, max_weight: 40)
defmodule Cargo do
  @behaviour Problem
  alias Types.Chromosome

  # generate a new individuum
  # for each item, we flip a coin to determine whether to include it or not
  @impl true
  def genotype do
    genes = for _ <- 1..10, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 10}
  end

  # compute fitness for the given individuum
  #   @return sum of values of the chosen items
  @impl true
  def fitness_function(chromosome) do
    profits = [6, 5, 8, 9, 6, 7, 3, 1, 2, 6]
    profits
    |> Enum.zip(chromosome.genes)
    |> Enum.map(fn {p, g} -> p*g end)
    |> Enum.sum
  end

  @impl true
  def terminate?(population) do
    Enum.max_by(population, &Cargo.fitness_function/1).fitness == 53
  end

end

soln = Genetic.run(Cargo, population_size: 50)

IO.write("\n")
IO.inspect(soln)

weight = 
  soln.genes
  |> Enum.zip([10, 6, 8, 7, 10, 9, 7, 11, 6, 8])
  |> Enum.map(fn {g, w} -> w*g end)
  |> Enum.sum()

IO.write("\Weight is: #{weight}\n")
