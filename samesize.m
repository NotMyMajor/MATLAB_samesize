%% Takes any number of cell or double arrays and resizes them all to the same dimensions. Also serves to resize any array with removal of extra rows/columns and adding of NaN, 0, or empty string rows/columns.

% Matrices can be truncated to match the smallest dimensions of the
% matrices, or extended with a filler value to match the largest dimensions
% of the matrices. For this behavior, the program will find the
% minimum and maximum number of rows and columns from all the inputted
% arrays and use those to set the dimensions of all arrays depending on
% whether "small" or "big" was selected in the options. Default is "big".

% Matrices can also be resized to certain inputted dimensions, in which case too large dimesions will be truncated and too small will be filled.
% The matrix filler defaults to NaN but can also be set to zero or an empty string.
% One output matrix is given for every input matrix.
% You can even mix inputs of double arrays and cell arrays and each array will be passed back in the same form it entered.
% See arguments notes below.

% varargin: Any number of arrays of either class double or cell can be passed in. They can be of any size. One output is created for each input array.

% Name-Value Pair Arguments:
% RowCol: Manually sets the desired size of the output matrices. Must be submitted as a 1x2 non-zero integer vector indicating [rowsize, columnsize].
% SmallBig: Sets whether to truncate larger matrices to the size of the smallest dimesions of any matrix, or extend smaller matrices to the size of the largest. Must be either "small" or "big". Defaults to "big". If the rows and columns have been manually set, this input is ignored.
% Filler: Sets whether to fill extra rows and columns with NaN, zero, or an empty string (only for cell arrays). Must be "NaN", "nan", "zero", "0", "String", or "string". Defaults to "NaN".

% Outputs:
% varargout: Ouputs one array for each array in the input. They can be accessed in the order they were entered. You do not necessarily have to take every output that is generated.
% Example: [a,b] = samesize(a,b,c,d) will return output for a and b but not c and d. However, if you want just c and d, the call must look like [~,~,c,d] = samesize(a,b,c,d).

% Example function call with minimum arguments:
% samesize(a,b) (where a and b are arrays of class cell or double)
% In this case, default behavior will resize a and b to the largest dimensions of the arrays.

% With output:
% [a,b] = samesize(a,b)

% With optional arguments for manual dimensions:
% [a,b] = samesize(a,b,"RowCol", [3,4])

% With optional argument for shrinking to smallest or expanding to biggest:
% [a,b] = samesize(a,b,"SmallBig", "small")

% With optional argument for filler type:
% [a,b] = samesize(a,b,"Filler","zero")

% A note on behavior:
% As mentioned above, the default response of the program is to make all
% arrays the size of the largest dimensions of the arrays given. For
% example, if you submit a 1x3 matrix and a 3x1 matrix, the result will be
% 3x3 matrices with 2 rows of NaN for the first matrix and two columns of 
% NaN for the second, as this is the largest combination of rows and 
% columns of the matrices given. Likewise, if you submit a 3x3 matrix and 
% a 1x3 matrix, the result will be 3x3 matrices with no changes to the 
% first matrix and two rows of NaN for the second.

% This same behavior applies to the "small" 
% option. (i.e. an input of a 2x3 matrix and a 3x2 matrix with "small" 
% selected will output 2x2 matrices with the extra column of the first
% matrix and the extra row of the second removed.)

function varargout = samesize(varargin,options)

arguments (Repeating)
    
    varargin (:,:) {mustBeA(varargin, ["double", "cell"])}
    
end

% Specify input arguments, name-value pairs, and default values.
arguments
    
    options.RowCol (1,2) {mustBeNumeric,mustBeReal,mustBeInteger} = [0,0]
    options.SmallBig {mustBeMember(options.SmallBig,["small","big"])} = "big"
    options.Filler {mustBeMember(options.Filler, ["NaN", "nan", "0", "zero", "string", "String"])} = "NaN"
    
end

nOutputs = nargout;

if options.Filler == "NaN" || options.Filler == "nan"
    filler = NaN;
elseif options.Filler == "string" || options.Filler == "String"
    filler = "";
else
    filler = 0;
end

if options.RowCol(1) ~= 0 && options.RowCol(2) ~= 0
%     fprintf("Resizing arrays...")
    for i=1:size(varargin, 2)
        [numrows, numcols] = size(varargin{i});
        rowdiff = numrows - options.RowCol(1);
        coldiff = numcols - options.RowCol(2);
        % Fix rows.
        if rowdiff > 0
            for rd=rowdiff:-1:1
                varargin{i}((options.RowCol(1)+rd), :) = [];
            end % For rd
        elseif rowdiff < 0
            for rd=1:abs(rowdiff)
                if class(varargin{i}) == "double"
                    if class(filler) == "string"
                        error("ERROR in sizesame. Input arrays included a double matrix, but filler was set to 'string'. Cannot populate double arrays with empty strings. Please set argument 'Filler' to either 'NaN' or 0 or change the matrix to a cell matrix.");
                    end
                    varargin{i}((numrows+rd), :) = filler;
                elseif class(varargin{i}) == "cell"
                    varargin{i}((numrows+rd), :) = {filler};
                end
            end % For rd
        end
        
        % Fix columns.
        if coldiff > 0
            for cd=coldiff:-1:1
                varargin{i}(:, (options.RowCol(2)+cd)) = [];
            end
        elseif coldiff < 0
            for cd=1:abs(coldiff)
                if class(varargin{i}) == "double"
                    if class(filler) == "string"
                        error("ERROR in sizesame. Input arrays included a double matrix, but filler was set to 'string'. Cannot populate double arrays with empty strings. Please set argument 'Filler' to either 'NaN' or 0 or change the matrix to a cell matrix.");
                    end
                    varargin{i}(:, (numcols+cd)) = filler;
                elseif class(varargin{i}) == "cell"
                    varargin{i}(:, (numcols+cd)) = {filler};
                end
            end % For cd
        end
    end % For i
%     fprintf("Done\n");
    
elseif options.RowCol(1) ~= 0 && options.RowCol(2) == 0
    error("ERROR in sizesame(). At least one value in RowCol was zero. All values of RowCol must be nonzero to use manual sizing.");

elseif options.RowCol(1) == 0 && options.RowCol(2) ~= 0
    error("ERROR in sizesame(). At least one value in RowCol was zero. All values of RowCol must be nonzero to use manual sizing.");

else
    if length(varargin) < 2
        warning("WARNING in sizesame(). Only one matrix passed in, but RowCol was unset. Default behavior for this case is to pass back the original matrix unaltered. If you meant to change the size of this single matrix, set the 'RowCol' argument. If you meant to match this matrix size to another matrix (or vice versa), pass in multiple matrices.");
    else
        min_row = inf;
        min_col = inf;
        max_row = 0;
        max_col = 0;
        % Get minimum and maximum sizes of arrays.
%         fprintf("Finding minimum and maximum sizes...\n")
        for i=1:size(varargin, 2)
            if size(varargin{i}, 1) < min_row
                min_row = size(varargin{i}, 1);
            end
            if size(varargin{i}, 1) > max_row
                max_row = size(varargin{i},1);
            end
            if size(varargin{i}, 2) < min_col
                min_col = size(varargin{i}, 2);
            end
            if size(varargin{i}, 2) > max_col
                max_col = size(varargin{i}, 2);
            end
        end % For i
%         fprintf("Done\n");
        
        % Fix dimensions.
%         fprintf("Resizing arrays...\n")
        if options.SmallBig == "small"
            for i=1:size(varargin, 2)
                [numrows, numcols] = size(varargin{i});
                rowdiff = numrows - min_row;
                if rowdiff > 0
                    for rd=rowdiff:-1:1
                        varargin{i}((min_row+rd), :) = [];
                    end
                end
                coldiff = numcols - min_col;
                if coldiff > 0
                    for cd=coldiff:-1:1
                        varargin{i}(:, (min_col+cd)) = [];
                    end
                end
            end % For i
        else
            for i=1:size(varargin, 2)
                [numrows, numcols] = size(varargin{i});
                rowdiff = max_row - numrows;
                if rowdiff > 0
                    for rd=1:rowdiff
                        if class(varargin{i}) == "double"
                            if class(filler) == "string"
                                error("ERROR in sizesame. Input arrays included a double matrix, but filler was set to 'string'. Cannot populate double arrays with empty strings. Please set argument 'Filler' to either 'NaN' or 0 or change the matrix to a cell matrix.");
                            end
                            varargin{i}((numrows+rd), :) = filler;
                        elseif class(varargin{i}) == "cell"
                            varargin{i}((numrows+rd), :) = {filler};
                        end
                    end % For rd
                end
                coldiff = max_col - numcols;
                if coldiff > 0
                    for cd=1:coldiff
                        if class(varargin{i}) == "double"
                            if class(filler) == "string"
                                error("ERROR in sizesame. Input arrays included a double matrix, but filler was set to 'string'. Cannot populate double arrays with empty strings. Please set argument 'Filler' to either 'NaN' or 0 or change the matrix to a cell matrix.");
                            end
                            varargin{i}(:, (numcols+cd)) = filler;
                        elseif class(varargin{i}) == "cell"
                            varargin{i}(:, (numcols+cd)) = {filler};
                        end
                    end % For cd
                end
            end % For i
        end
%         fprintf("Done\n");
    end
    
end

% fprintf("Assigning outputs...\n");
varargout = cell(1,nOutputs);
for n=1:nOutputs
    varargout{n} = varargin{n};
end % For n
% fprintf("Done\n");

end


% samesize.m Resizing and size matching of arrays for MATLAB.
% Copyright (C) 2022 Rhys Switzer
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.