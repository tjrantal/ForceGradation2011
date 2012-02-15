close all
x = 0:0.1:2*pi;
y = sin(x);
figureToPlotTo = figure;
		set(figureToPlotTo,'position',[10 10 1200 300],'visible','on');	
		
plot(x,y)
hold on
y2 = sin(2*x);
plot(x,y2)
plot(x(19:44),y(19:44),'g')
plot(x(19:44),y2(19:44),'r')
box('off')
print('-dpng',['-S' num2str(1200) ',' num2str(300)],'whatever');
		close(figureToPlotTo);