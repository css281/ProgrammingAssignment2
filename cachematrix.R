## Computionally intensive operations in R may potentially benefit from caching 
## the result of processing input dataset. Retrieving result from cache avoids 
## re-processing when the input is unchanged and the same operation is performed again.
## Performance benefits and resource usage optimization could be very significant.
## As an example, matrix inversion is one such computation and the two functions below
## illustrate this concept where a square invertible matrix is the input and the inverse 
## is computed once and stored in cache for subsequent retrievals.

## 1. makeCacheMatrix(): This function creates a special "matrix" object that can cache its inverse.
## 2. cacheSolve(): This function computes the inverse of the special "matrix" returned by 
##    makeCacheMatrix above. If the inverse has already been calculated (and the matrix has not changed), 
##    then the cachesolve should retrieve the inverse from the cache.

## Sample test run log with comments have been included in the file TEST_RUNS.md


makeCacheMatrix <- function(x = matrix()) {
        ## input: square invertible matrix, defaulted to a 1x1 matrix
        ## return: list of the following functions which is used as an input to cacheSolve()
        ## 1. set matrix
        ## 2. get matrix
        ## 3. set matrix inverse
        ## 4. get matrix inverse
        
        ## Create object to store cache and initialize to NULL
        inverseCache <- NULL 
        
        ## <<- operatorcreates a variable in an environment outside the current env
        ## Create the matrix
        set <- function(y) {
                x <<- y       ## 
                inverseCache <<- NULL
        }
        
        ## Retrieve the matrix
        get <- function() x
        
        ## Store the computed inverse in cahe
        setinv <- function(inverse) inverseCache <<- inverse
        
        ## Retrieve inverse form cache
        getinv <- function() inverseCache
        
        ## return list of set/get functions 
        list(set = set, get = get, setinv = setinv, getinv = getinv)
}


## cacheSolve(): computes the inverse of the matrix returned by makeCacheMatrix().
## If the inverse has already been calculated and the matrix has not changed,
## it retrieves the inverse from the cache.
cacheSolve <- function(x, ...) {
        ## input: the list object from makeCacheMatrix()
        ## return: inverse of the matrix input to makeCacheMatrix()
        
        ## Retrieve the inverse from cache
        inverseCache <- x$getinv()
        
        ## Return inverted matrix if it exists in cache, implying a prior calculated inverse has been cached
        if (!is.null(inverseCache)) {
                message("Retrieving cached inverse")
                return(inverseCache)
        }
        
        ## Otherwise get the matrix using the get fuction and compute the inverse using solve()
        m <- x$get()
        inverseCache <- solve(m, ...)
        
        ## store the computed inverse in the cache using the setinv function.
        x$setinv(inverseCache)
        
        ## return the inverse
        return(inverseCache)
}
