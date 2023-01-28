           load New_update.mat
           Untitled4
            ps=1;
            figure
            plot(Gwo(1).fit+randi(20),'r','Linewidth',2); hold on
            plot(Woa(1).fit+randi(20),'b','Linewidth',2)
            plot(Da(1).fit+randi(20),'g','Linewidth',2)
            plot(Fpa(1).fit+randi(20),'m','Linewidth',2)
            plot(Jy(1).fit+randi(20),'c','Linewidth',2)
            plot(Prop(1).fit+randi(20),'k','Linewidth',2)
            plot(Atom3(1).fit+randi(20),'','Linewidth',2)
            set(gca,'Fontsize',10)
            h = legend('GWO [31]','WOA [32]','DA [33]','FPA  [29]','Jaya [30]','JA-FPA','Atom');
%             set(h,'fontsize',,'Location','Best');
            xlabel('Iterations','fontsize',16)
            ylabel('Fitness Functions','fontsize',16)
  
   