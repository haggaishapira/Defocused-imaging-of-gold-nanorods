function [molecules,num_mol] = current_or_all(plot_info,combine_statistics)

    if combine_statistics
        molecules = plot_info.all_mol;
        num_mol = plot_info.num_mol_all;
    else
        molecules = plot_info.curr_mol;
        num_mol = plot_info.num_mol_curr;
    end
