alias Types.Chromosome

defmodule Genetic do

  # Run genetic algorithm for the given problem
  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)
    generation = 0
    population
    |> evolve(problem, generation, opts)
  end

  # Stepwise evolve the given population  
  def evolve(population, problem, generation, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)
    best = hd(population)
    IO.write("\rCurrent Best: #{best.fitness}, phenotype: #{best.genes}")
    if problem.terminate?(population, generation) do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(problem, generation+1, opts)
    end
  end

  # Initialize a population using the given function to instantiate a genotyp
  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  # Evaluate the given population with the given fitness function
  # @returns Population, sorted by fitness
  def evaluate(population, fitness_function, opts \\ []) do
    population
    |> Enum.map(
         fn chromosome ->
           fitness = fitness_function.(chromosome)
           age = chromosome.age + 1
           %Chromosome{chromosome | fitness: fitness, age: age}
         end
       )
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  # Select individuums for crossover
  # @returns pair of individua 
  def select(population, opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

  # Perform crossover 
  # @param population list of 2-tuples (= parents) selected for crossover
  # @returns new population (= children)
  def crossover(population, opts \\ []) do
    population
    |> Enum.reduce([], 
         fn {p1, p2}, acc ->
           cx_point = :rand.uniform(length(p1.genes))
           {{h1, t1}, {h2, t2}} =
            {Enum.split(p1.genes, cx_point),
            Enum.split(p2.genes, cx_point)}
           {c1, c2} = { %Chromosome{p1 | genes: h1 ++ t2},
                        %Chromosome{p2 | genes: h2 ++ t1} }
           [c1, c2 | acc]
         end
        )
  end

  # Mutate a certain percentage (5%) of the given population
  def mutation(population, opts \\ []) do
    population
    |> Enum.map(
         fn chromosome -> 
           if :rand.uniform() < 0.05 do
             %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
           else
             chromosome
           end
         end
       )
  end

end
