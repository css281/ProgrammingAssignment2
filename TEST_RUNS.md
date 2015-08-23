## I've documented sample run of the functions in Programing Assignment 2 below.
### Create a 3000 by 3000 input matrix
> x<-matrix(runif(3000^2), 3000)
> str(x)
 num [1:3000, 1:3000] 0.358 0.802 0.988 0.404 0.403 ...

### The elapsed time shows how long it takes to compute the index
> system.time(solve(x))
   user  system elapsed 
  29.86    0.03   30.19 

### Source our functions and execute `makeCacheMatrix()` with the matrix we created as input
> source("cachematrix.R")
> ml<-makeCacheMatrix(x)

### Show the list of functions created, look at the environment address tags and how it varies each time makeCacheMatrix is called.
> ml
$set
function (y) 
{
    x <<- y
    inverseCache <<- NULL
}
<environment: 0x0000000017c1d450>

$get
function () 
x
<environment: 0x0000000017c1d450>

$setinv
function (inverse) 
inverseCache <<- inverse
<environment: 0x0000000017c1d450>

$getinv
function () 
inverseCache
<environment: 0x0000000017c1d450>

### Use the `get()` and `getinv()` in ml functions to retrieve the matrix and show there is no inverse in cache
> str(ml$get())
 num [1:3000, 1:3000] 0.358 0.802 0.988 0.404 0.403 ...
> ml$getinv()
NULL

### Shows approx. how long `cacheSolve()` takes to compute the inverse using `system.time()` -- 28.30 seconds.
> system.time(cacheSolve(ml))
   user  system elapsed 
  28.07    0.05   28.30 
  
### Shows that inverse has been stored in cache
> str(ml$getinv())
 num [1:3000, 1:3000] 0.0325 0.0712 -0.0379 0.0267 -0.0189 ...
 
### Subsequent calls will retrieve inverse from cache almost instantly. 
> system.time(cacheSolve(ml))
Retrieving cached inverse
   user  system elapsed 
      0       0       0 
> system.time(cacheSolve(ml))
Retrieving cached inverse
   user  system elapsed 
      0       0       0

### Note that recreating ml will cause the inverse to be computed again by cacheSolve
> ml<-makeCacheMatrix(x)
> system.time(cacheSolve(ml))
   user  system elapsed 
  28.22    0.05   28.33 
> ml
$set
function (y) 
{
    x <<- y
    inverseCache <<- NULL
}
<environment: 0x0000000017c0a990>

$get
function () 
x
<environment: 0x0000000017c0a990>

$setinv
function (inverse) 
inverseCache <<- inverse
<environment: 0x0000000017c0a990>

$getinv
function () 
inverseCache
<environment: 0x0000000017c0a990>

### Subsequent calls utilize the cache again
> system.time(cacheSolve(ml))
Retrieving cached inverse
   user  system elapsed 
      0       0       0 
