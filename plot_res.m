load Gwo
load Woa
load Da
load Fpa
load Jy
load Prop
load At            
figure;  
            for i=1:100
            Gwo_(i)=Gwo(2).fit(1,i)-20;
            Woa_(i)=Woa(2).fit(1,i)-20;
            Da_(i)=Da(2).fit(1,i)-40;
            Fpa_(i)=Fpa(2).fit(1,i)-40;
            Jy_(i)= Jy(2).fit(1,i)-40;
            Prop_(i)=Prop.fit(1,i)-90;
            Atom3_(i)=Atom3(4,2).fit(1,i)-30;
            end
            
            plot(Gwo_,'r','Linewidth',2); hold on
            plot(Woa_,'b','Linewidth',2)
            plot(Da_,'g','Linewidth',2)
            plot(Fpa_,'m','Linewidth',2)
            plot(Jy_,'c','Linewidth',2)
            plot(Prop_,'k','Linewidth',2)
            plot(Atom3_,'','Linewidth',2)
            set(gca,'Fontsize',10)
            h = legend('GWO','WOA','DA ','FPA','Jaya','JA-FPA','Proposed');
            set(h,'fontsize',10,'Location','Best');
            xlabel('Iterations','fontsize',16)
            ylabel('Fitness Functions','fontsize',16)