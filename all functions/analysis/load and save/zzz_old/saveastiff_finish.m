function res = saveastiff_finish(data, path, options)


tfile.close();
if exist('path_parent', 'var'), cd(path_parent); end

tElapsed = toc(tStart);
if options.message
    display(sprintf('The file was saved successfully. Elapsed time : %.3f s.', tElapsed));
end

catch exception
%% Exception management
    if exist('tfile', 'var'), tfile.close(); end
    switch errcode
        case 1
            if options.message, error '''data'' is empty.'; end;
        case 2
            if options.message, error 'Data dimension is too large.'; end;
        case 3
            if options.message, error 'Third dimesion (color depth) should be 3 or 4.'; end;
        case 4
            if options.message, error 'Color image cannot have int8, int16 or int32 format.'; end;
        case 5
            if options.message, error 'Unsupported Matlab data type. (char, logical, cell, struct, function_handle, class)'; end;
        case 6
            if options.message, error 'File already exists.'; end;
        case 7
            if options.message, error(['Failed to open the file ''' path '''.']); end;
        otherwise
            if exist('fname', 'var') && exist('fext', 'var')
                delete([fname fext]);
            end
            if exist('path_parent', 'var'), cd(path_parent); end
            rethrow(exception);
    end
    if exist('path_parent', 'var'), cd(path_parent); end
end
res = errcode;
end