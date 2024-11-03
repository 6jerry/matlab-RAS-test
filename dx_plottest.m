
test1=dynamic_plot;
test2=dynamic_plot;
test1.create_figure(0.005,[600,600,600,600],'test1plot','no',[-200,200],[-100,100],'speedx');
test2.create_figure(0.008,[800,300,600,600],'test1plot2','no',[-200,200],[-100,100],'speedx');
curveData(1).id = 1;
curveData(1).data = -1; % 示例数据
curveData(1).text = 'Sine Wave';
curveData(1).lineWidth = 2;
curveData(1).lineStyle = '-';
curveData(1).textFontSize = 10;
curveData(1).colour = 'r'; % 红色
curveData(1).textvalue=0;

curveData(2).id = 2;
curveData(2).data = 1; % 示例数据
curveData(2).text = 'Cosine Wave';
curveData(2).lineWidth = 1.5;
curveData(2).lineStyle = '--';
curveData(2).textFontSize = 10;
curveData(2).colour = 'b'; % 蓝色
curveData(2).textvalue=0;

curveData(3).id = 3;
curveData(3).data = 0.21; % 示例数据
curveData(3).text = 'Cosine Wave';
curveData(3).lineWidth = 2;
curveData(3).lineStyle = '--';
curveData(3).textFontSize = 10;
curveData(3).colour = 'b'; % 蓝色
curveData(3).textvalue=0;

curveData(4).id = 4;
curveData(4).data = -0.21; % 示例数据
curveData(4).text = 'Cosine Wave';
curveData(4).lineWidth = 2;
curveData(4).lineStyle = '--';
curveData(4).textFontSize = 10;
curveData(4).colour = 'g'; % 蓝色
curveData(4).textvalue=0;

curveData(5).id = 5;
curveData(5).data = 0.51; % 示例数据
curveData(5).text = 'Wave';
curveData(5).lineWidth = 0.8;
curveData(5).lineStyle = '-.';
curveData(5).textFontSize = 10;
curveData(5).colour = 'g'; % 蓝色
curveData(5).textvalue=0;

curveData(6).id = 6;
curveData(6).data = -0.51; % 示例数据
curveData(6).text = 'Wave';
curveData(6).lineWidth = 0.8;
curveData(6).lineStyle = '-.';
curveData(6).textFontSize = 10;
curveData(6).colour = 'g'; % 蓝色
curveData(6).textvalue=0;


% 启动绘图
delta_time = [-7, 4]; % X 轴范围
delta_y = [-1.5, 1.5]; % Y 轴范围
%test1.startploting(delta_time,0.05, delta_y, curveData);
 %test2.startploting(delta_time,0.05, delta_y, curveData);

