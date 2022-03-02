# MATLAB_samesize
Takes any number of cell or double arrays and resizes them all to the same dimensions. Also serves to resize any array with removal of extra rows/columns and adding of NaN, 0, or empty string rows/columns.

## Table of Contents
* [Overview](#overview)
* [Arguments](#arguments)
* [Examples](#examples)
* [Notes and Warnings](#notes-and-warnings)

## Overview
Matrices can be truncated to match the smallest dimensions of the
matrices, or extended with a filler value to match the largest dimensions
of the matrices. For this behavior, the program will find the
minimum and maximum number of rows and columns from all the inputted
arrays and use those to set the dimensions of all arrays depending on
whether "small" or "big" was selected in the options. Default is "big".

Matrices can also be resized to certain inputted dimensions, in which case too large dimesions will be truncated and too small will be filled.
The matrix filler defaults to NaN but can also be set to zero or an empty string.
One output matrix is given for every input matrix.
You can even mix inputs of double arrays and cell arrays and each array will be passed back in the same form it entered.
See arguments notes below.

## Arguments

* varargin: Any number of arrays of either class double or cell can be passed in. They can be of any size. One output is created for each input array.

```MATLAB
samesize(array1,array2,array3,array4,...)
```

### Name-Value Pair Arguments:

* RowCol: Manually sets the desired size of the output matrices. Must be submitted as a 1x2 non-zero integer vector indicating [rowsize, columnsize].

* SmallBig: Sets whether to truncate larger matrices to the size of the smallest dimesions of any matrix, or extend smaller matrices to the size of the largest. Must be either "small" or "big". Defaults to "big". If the rows and columns have been manually set, this input is ignored.

* Filler: Sets whether to fill extra rows and columns with NaN, zero, or an empty string (only for cell arrays). Must be "NaN", "nan", "zero", "0", "String", or "string". Defaults to "NaN".

### Outputs:

varargout: Ouputs one array for each array in the input. They can be accessed in the order they were entered. You do not necessarily have to take every output that is generated.

Example: 
```MATLAB
[a,b] = samesize(a,b,c,d)
```
will return output for a and b but not c and d. However, if you want just c and d, the call must look like
```MATLAB
[~,~,c,d] = samesize(a,b,c,d)
```

## Examples

Example function call with minimum arguments:

```MATLAB
samesize(a,b) %(where a and b are arrays of class cell or double)
```

In this case, default behavior will resize a and b to the largest dimensions of the arrays.

With output:

```MATLAB
[a,b] = samesize(a,b)
```

With optional arguments for manual dimensions:

```MATLAB
[a,b] = samesize(a,b,"RowCol", [3,4])
```

With optional argument for shrinking to smallest or expanding to biggest:

```MATLAB
[a,b] = samesize(a,b,"SmallBig", "small")
```

With optional argument for filler type:

```MATLAB
[a,b] = samesize(a,b,"Filler","zero")
```

## Notes and Warnings

### A note on behavior:

As mentioned above, the default response of the program is to make all
arrays the size of the largest dimensions of the arrays given. For
example, if you submit a 1x3 matrix and a 3x1 matrix, the result will be
3x3 matrices with 2 rows of NaN for the first matrix and two columns of 
NaN for the second, as this is the largest combination of rows and 
columns of the matrices given. Likewise, if you submit a 3x3 matrix and 
a 1x3 matrix, the result will be 3x3 matrices with no changes to the 
first matrix and two rows of NaN for the second.

This same behavior applies to the "small" 
option. (i.e. an input of a 2x3 matrix and a 3x2 matrix with "small" 
selected will output 2x2 matrices with the extra column of the first
matrix and the extra row of the second removed.)

For manually set dimensions, all matrices will have rows/columns added or subtracted as necessary to make them the correct size.

### Warning:

I am not a professional developer or programmer. If there are unforseen issues or bugs please let me know, but no promises on the reliability of this function. I've done my best to think of all possible situations but it's likely I missed something. Thanks!

Also, I know matrices and arrays are technically not the same thing and I use the two pretty interchangeably in this documentation. Sorry about that. Don't be mean about it.

[![View MATLAB_samesize on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/107470-matlab_samesize)
