 fh1 = open('curva_nacional.fig');
 fh2 = open('curva_nacional_mov14.fig');
 ax1 = get(fh1, 'Children');
 ax2 = get(fh2, 'Children');
 ax2p = get(ax2(1),'Children');
 copyobj(ax2p, ax1(1));