# Concurrency and Parallel Programming
#
# Sebastian Gonzalez Villacorta
# A01029746
# Karla Mondragón Rosas
# A01025108
# 10-06-2022

defmodule Hw.Primes do
  #function that returns if a number is prime or not
  def is_prime(2), do: :true
  def is_prime(n), do: do_is_prime(2, Float.ceil(:math.sqrt(n)), n)

    defp do_is_prime(_start, _limit, n) when n<2, do: :false
    defp do_is_prime(start, limit, _res) when start > limit, do: :true
    defp do_is_prime(start, limit, n) do 
      if (rem(n, start)==0) do
        :false  
      else 
        do_is_prime(start+1, limit, n)
      end
    end

  #function that sums primes sequentially 
  def sum_primes(lsuperior), do: do_sum_primes(2, lsuperior, 0)
  def sum_primes(_linferior, lsuperior) when lsuperior<2, do: 0
  def sum_primes(linferior, lsuperior), do: do_sum_primes(linferior, lsuperior, 0)
    
    #function that returns the sum of the prime numbers within a range, sequencial
    defp do_sum_primes(linferior, lsuperior, res) when linferior>lsuperior, do: res 
    defp do_sum_primes(linferior, lsuperior, res) do
        if(is_prime(linferior)) do
          do_sum_primes(linferior+1, lsuperior, res+linferior)
        else
          do_sum_primes(linferior+1, lsuperior, res)
        end
    end 

    #function that sums primes paralelly
    # up to 8 threads
  def sum_primes_parallel(limit, threads \\ System.schedulers) do
      #remainders =  rem(limit, threads)
      range = div(limit, threads)
      #Formula to calculate the numbers in each thread
      1..threads
        |>Enum.map(&Task.async(fn -> do_sum_primes((1 + (&1 - 1) * range), 
                                      (&1 * range), 0) end))
        |>Enum.map(&Task.await(&1, :infinity))
        |>Enum.sum()
    end
end