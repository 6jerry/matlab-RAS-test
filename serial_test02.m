% 生成时间和速度数据
t = 0:0.1:10;          % 时间轴
speed = sin(t) * 10;    % 假设速度随时间的正弦变化，单位为 m/s

% 创建图形窗口和曲线
figure;
plotHandle = plot(t, speed, 'r', 'LineWidth', 1.5); % 绘制红色的速度曲线
hold on;
xlabel('Time (s)');
ylabel('Speed (m/s)');
title('Real-time Speed Plot');
grid on;

% 添加一个静态的文本标签
textLabel = text(1, max(speed), 'Speed (m/s)', 'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold');

% 动态显示最新的速度值
dynamicText = text(t(end), speed(end), sprintf('%.2f m/s', speed(end)), ...
                   'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold');

% 动态更新曲线和标签
for i = 1:length(t)
    % 更新曲线数据
    set(plotHandle, 'XData', t(1:i), 'YData', speed(1:i));
    
    % 更新动态文本的位置和显示的值
    set(dynamicText, 'Position', [t(i), speed(i)], 'String', sprintf('%.2f m/s', speed(i)));
    
    % 强制刷新图像
    drawnow;
    
    % 模拟实时数据
    pause(0.1);
end



