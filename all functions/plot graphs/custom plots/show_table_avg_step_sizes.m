function show_table_avg_step_sizes(step_reactions,first_t,last_t,settings)

    data_table = [];

    for i=1:6
        filtered_step_reactions = filter_step_reactions(step_reactions(:),i,first_t,last_t,settings);
        vals = get_data_simple(filtered_step_reactions,'step_size');
%         vals_fig(vals_fig<0) = 0;
        avg_step_size = mean(vals);
        data_table = [data_table; avg_step_size];
    end

%     figure
    f=figure('Color',[1 1 1]);
    f.Position(2) = f.Position(2)  * 0.5;
%     names = {'1->3';'2->4';'3->5';'4->6';'5->1';'6->2'};
%     T=table(data_table);
    T=uitable(f, 'Data', data_table);
%     T.ColumnName = T.Properties.VariableNames;
    T.FontSize = 14;
    









