function update_handles(src,handles)
    guidata(src,handles);
    setappdata(0,'handles',handles);
