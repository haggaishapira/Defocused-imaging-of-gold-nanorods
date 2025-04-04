function handles = set_analysis(handles,file_num,analysis,new)
    
    if new
        handles.analyses = [handles.analyses; analysis];
    else
        handles.analyses(file_num,:) = analysis;
    end

