chromosome_size = 1000
max_fitness = chromosome_size # maximum = each bit is 1

genotype = fn -> for _ <- 1..chromosome_size, do: Enum.random(0..1) end

fitness_function = fn chromosome -> Enum.sum(chromosome) end


solution = Genetic.run(fitness_function, genotype, max_fitness)
IO.write("\n")
IO.inspect(solution)
