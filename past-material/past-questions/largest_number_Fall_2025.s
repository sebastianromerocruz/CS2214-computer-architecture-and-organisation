# find the largest value in array
# store it into $5, then halt

#--- Python Solution---
# max = 0
# array = [8, 19, 1, 0, 14, 23, 39]
# array_start = 0, array_end = len(array)
# for (int i = array_start; i < array_end; i++):
#     if (array[i] > max):
#         max = array[i]

# your code


movi $5,0 # max is in $5
movi $1, array_start
movi $2, array_end

start_loop:
  jeq $1, $2, done
  lw $3, 0($1) # $3 = 8 for first iteration
  slt $4, $5, $3 # if ($5 < $3) $4 = 1, else $4 = 0
  addi $1, $1, 1
  jeq $4, $0, start_loop
  add $5, $3, $0 # $5 = $3+$0 = $3
  j start_loop
done:
  halt

array_start:
  .fill 8
  .fill 19
  .fill 1
  .fill 0
  .fill 14
  .fill 23
  .fill 39

array_end:
