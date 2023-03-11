defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome), do: Enum.sum(chromosome.genes)

  @impl true
  def terminate?(population), do: avg_terminate?(population)

  # Maximum Fitness Threshold
  def max_terminate?([ best | _]), do: best.fitness == 42

  # Minimum Fitness Threshold
  def min_terminate?(population), do:
    Enum.min_by(population, &OneMax.fitness_function/1) == 0

  # Average Fitness Threshold
  def avg_terminate?(population) do
    avg = 
      population
      |> Enum.map(&OneMax.fitness_function/1)
      |> Enum.sum() 
      |> (fn x -> x / length(population) end).()
    IO.write("avg: #{avg}")
    avg == 21
  end
end

solution = Genetic.run(OneMax)

IO.write("\n")
IO.inspect(solution)

