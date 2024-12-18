classdef dynamic_plot  < handle

    properties (Access=public)
        figs;%动态曲线区的结构体，包含窗口句柄，定时器句柄，axis句柄,要绘制的变量
    end

    methods
        function create_figure(obj,delay,position,name,title,axis_x,axis_y,y_label)
            obj.figs.Name=name;
            obj.figs.Position=position;
            obj.figs.Delay=delay;
            obj.figs.figure_handle=figure('Name', obj.figs.Name, 'NumberTitle', 'off');
            obj.figs.title=title;
            obj.figs.axis_x=axis_x;
            obj.figs.axis_y=axis_y;
% 在 MATLAB 中，可以通过设置 figure 的 Position 属性来控制窗口的大小和位置。Position 属性是一个包含四个元素的向量 [left, bottom, width, height]，分别表示：
% 
% left：窗口左边距，距离屏幕左侧的像素数
% bottom：窗口底边距，距离屏幕底部的像素数
% width：窗口宽度，单位为像素
% height：窗口高度，单位为像素
            obj.figs.figure_handle.Position= obj.figs.Position;
            obj.figs.axis_handle=axes(obj.figs.figure_handle,'Units', 'normalized','Position', [0.05, 0.05, 0.9, 0.9]);%设置坐标区能够动态变化
            set(obj.figs.axis_handle, 'Color', 'k', 'GridColor', 'w');  % 设置背景和网格
             axis(obj.figs.axis_handle,[axis_x(1) axis_x(2) axis_y(1) axis_y(2)]);%设置坐标轴初始范围
             xlabel(obj.figs.axis_handle, 'Time');
             obj.figs. y_label= y_label;
            ylabel(obj.figs.axis_handle,  obj.figs.y_label);
             grid on;
             %title(obj.figs.axis_handle, obj.figs.title); % 设置标题
             obj.figs.timer_handle=timer('ExecutionMode', 'fixedSpacing', ...
                               'Period',  obj.figs.Delay, ...
                               'TimerFcn', {@obj.timerCallback}...
                               ,'BusyMode','drop','Name',obj.figs.Name);

            

        end


         function timerCallback(obj, ~, ~)

            obj.figs.time_array = [obj.figs.time_array  obj.figs.time_array(end)+obj.figs.speed];%刷新x轴
             
             for j=1:length(obj.figs.curves)
                obj.figs.curves(j).y_array=[obj.figs.curves(j).y_array obj.figs.curves(j).data];
                if length(obj.figs.curves(j).y_array) > 3000
                    obj.figs.curves(j).y_array = obj.figs.curves(j).y_array(end-2999:end);
                    obj.figs.time_array = obj.figs.time_array(end-2999:end);
                end
                set(obj.figs.curves(j).text_handle, 'Position', [obj.figs.time_array(end-obj.figs.curves(j).textvalue), obj.figs.curves(j).y_array(end-obj.figs.curves(j).textvalue)], 'String', sprintf('%s:%.2f',obj.figs.curves(j).text, obj.figs.curves(j).y_array(end)));
                set(obj.figs.curves(j).plot_handle,'XData', obj.figs.time_array, 'YData', obj.figs.curves(j).y_array);
                % 更新y值标注
               
                
    
                
             end
                 drawnow limitrate;
           

            obj.figs.x=obj.figs.x+obj.figs.speed;
            axis(obj.figs.axis_handle,[obj.figs.x+obj.figs.delta_time(1) obj.figs.x + obj.figs.delta_time(2)  obj.figs.delta_y(1) obj.figs.delta_y(2)]);
             %disp( obj.figs(id).Name);\
           
             
            
         end

         function startploting(obj,delta_time,speed,delta_y,curveData)%初始化对应窗口的曲线并且启动对应的定时器
            %装填该窗口内将要绘制的所有曲线的配置信息
              for i = 1:length(curveData)
                    obj.figs.curves(curveData(i).id).data=curveData(i).data;
                    obj.figs.curves(curveData(i).id).text=curveData(i).text;
                    obj.figs.curves(curveData(i).id).textvalue=curveData(i).textvalue;
                     obj.figs.curves(curveData(i).id).lineWidth=curveData(i).lineWidth;
                     obj.figs.curves(curveData(i).id).lineStyle=curveData(i).lineStyle;%实线 ('-'),虚线 ('--'),点线 (':'),点划线 ('-.')
                     obj.figs.curves(curveData(i).id).textFontSize=curveData(i).textFontSize;
                     obj.figs.curves(curveData(i).id).colour=curveData(i).colour;
                    %  红色	'r'	
                    % 绿色	'g'	
                    % 蓝色	'b'	
                    % 青色	'c'	
                    %洋红色	'm'	
                    % 黄色	'y'	
                    % 黑色	'k'	
                    % 白色	'w'
              end
                 obj.figs.time_array=[0];%初始化时间向量
                 obj.figs.delta_time=delta_time;%决定整体图像在x轴上的拉伸程度
                 obj.figs.delta_y=delta_y;   
                 set(obj.figs.axis_handle, 'Color', 'k', 'GridColor', 'w');
                 xlabel(obj.figs.axis_handle, 'Time');
                ylabel(obj.figs.axis_handle,  obj.figs. y_label);
               hold(obj.figs.axis_handle, 'on');
              for j=1:length(obj.figs.curves)
                  obj.figs.curves(j).y_array=[0];
                   obj.figs.curves(j).plot_handle=plot(obj.figs.axis_handle,obj.figs.time_array,obj.figs.curves(j).y_array,'LineStyle',obj.figs.curves(j).lineStyle...
                       ,'LineWidth',obj.figs.curves(j).lineWidth,'DisplayName',obj.figs.curves(j).text,'Color',obj.figs.curves(j).colour);

                  obj.figs.curves(j).text_handle = text(obj.figs.axis_handle, 0, 0, obj.figs.curves(j).text, 'Color', 'w', 'FontSize', ...
                      obj.figs.curves(j).textFontSize);


              end
             hold(obj.figs.axis_handle, 'off');
             grid on;
               %设置初相位
               obj.figs.x=0;
               obj.figs.speed=speed;
               axis(obj.figs.axis_handle,[obj.figs.x+obj.figs.delta_time(1) obj.figs.x+obj.figs.delta_time(2)  obj.figs.delta_y(1) obj.figs.delta_y(2)]);
                start(obj.figs.timer_handle);
             

         end
         function stoploting(obj)
             stop(obj.figs.timer_handle);
            delete(obj.figs.timer_handle);
            delete(obj.figs.figure_handle);
         end

         function pauseploting(obj)
              stop(obj.figs.timer_handle);
         end
       
         function set_data(obj,curveid,data)

              obj.figs.curves(curveid).data=data;

         end

         function set_visible_x(obj,visible_x)
            obj.figs.delta_time=visible_x;
         end
         function set_visible_y(obj,visible_y)
             obj.figs.delta_y=visible_y;
         end

         function set_text_pos(obj,id,textpos)
            obj.figs.curves(id).textvalue=textpos;

         end
         function add_curve(obj,curveData)
             obj.figs.curves(curveData.id).data=curveData.data;
                    obj.figs.curves(curveData.id).text=curveData.text;
                    obj.figs.curves(curveData.id).textvalue=curveData.textvalue;
                     obj.figs.curves(curveData.id).lineWidth=curveData.lineWidth;
                     obj.figs.curves(curveData.id).lineStyle=curveData.lineStyle;%实线 ('-'),虚线 ('--'),点线 (':'),点划线 ('-.')
                     obj.figs.curves(curveData.id).textFontSize=curveData.textFontSize;
                     obj.figs.curves(curveData.id).colour=curveData.colour;
         end
        


    end


end