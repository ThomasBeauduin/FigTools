load data\ex10_linePlot points x y

hfig=figure;
plot(points(:,1),points(:,2),':ok'), hold on
plot(x, y), axis([.5 7 -.8 1.8])
    title('Convex-Hull Property')
    xlabel('x')
    ylabel('y')
    xt = points(3,1) - 0.05;
    yt = points(3,2) - 0.1;
    text(xt, yt, 'Point 3')

    xt = points(4,1) - 0.05;
    yt = points(4,2) + 0.1;
    text(xt, yt, 'Point 4')

    xt = points(5,1) + 0.15;
    yt = points(5,2) - 0.05;
    text(6.1,.5, 'Point 5')
hfig=pubfig(hfig)
expfig('ex10_linePlot','-pdf',hfig);