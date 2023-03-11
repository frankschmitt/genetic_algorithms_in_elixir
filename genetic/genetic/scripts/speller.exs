defmodule Speller do
  @behaviour Problem
  alias Types.Chromosome

  # words with 34 characters
  def genotype do
    genes = 
      Stream.repeatedly(fn -> Enum.random(?a .. ?z) end)
      |> Enum.take(34)
    %Chromosome{genes: genes, size: 34}
  end

  def fitness_function(chromosome) do
    target = "supercalifragilisticexpialidocious"
    guess = List.to_string(chromosome.genes)
    # jaro_distance returns the *similarity* between strings (1 = identical)
    String.jaro_distance(target, guess)
  end

  def terminate?([ best | _], generation) do
    (best.fitness == 1) || (generation >= 100)
  end

end

solution = Genetic.run(Speller)

IO.write("\n")
IO.inspect(solution)
