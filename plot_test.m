% 初始化数据
t = [0];
m_sin = sin(t);
m_cos = cos(t);

% 创建两个图形窗口和初始曲线
f1 = figure('Name', 'Measured Data - Sin', 'NumberTitle', 'off');
ax1 = axes(f1);  % f1窗口的坐标轴
global p_sin sin_text timerSin timerCos % 声明全局变量
p_sin = plot(ax1, t, m_sin, 'g', 'MarkerSize', 5);  % 正弦曲线
hold on;
axis(ax1, [-1.5 * pi, -1.5 * pi + 2 * pi, -1.5, 1.5]); % 设置轴范围
grid on;
set(ax1, 'Color', 'k', 'GridColor', 'w');  % 设置背景和网格
sin_text = text(ax1, 0, 0, '', 'Color', 'w', 'FontSize', 10); % 正弦曲线的y值标注

f2 = figure('Name', 'Measured Data - Cos', 'NumberTitle', 'off');
ax2 = axes(f2);  % f2窗口的坐标轴
p_cos = plot(ax2, t, m_cos, 'b', 'MarkerSize', 5);  % 余弦曲线
hold on;
axis(ax2, [-1.5 * pi, -1.5 * pi + 2 * pi, -1.5, 1.5]);
grid on;
set(ax2, 'Color', 'k', 'GridColor', 'w');
cos_text = text(ax2, 0, 0, '', 'Color', 'w', 'FontSize', 10); % 余弦曲线的y值标注

% 创建两个定时器对象
t_update = 0.01; % 时间步长
timerSin = timer('ExecutionMode', 'fixedRate', ...
                 'Period', t_update, ...
                 'TimerFcn', @(~,~) updateSinPlot(ax1), ...
                 'StopFcn', @(~,~) disp('正弦曲线定时器已停止'));

timerCos = timer('ExecutionMode', 'fixedRate', ...
                 'Period', t_update, ...
                 'TimerFcn', @(~,~) updateCosPlot(ax2), ...
                 'StopFcn', @(~,~) disp('余弦曲线定时器已停止'));

% 启动两个定时器
start(timerSin);
start(timerCos);

% 定时器1的回调函数：更新正弦曲线
function updateSinPlot(ax1)
    global p_sin sin_text timerSin
    persistent i x1
    if isempty(i), i = 1; x1 = -1.5 * pi; end
    
    % 更新正弦曲线数据
    t = [p_sin.XData 0.1 * i];
    m_sin = [p_sin.YData sin(0.01 * i)];
    % 限制数据量：仅保留最近1000个点
    if length(t) > 1000
        t = t(end-999:end);
        m_sin = m_sin(end-999:end);
    end
    set(p_sin, 'XData', t, 'YData', m_sin);
    
    % 更新y值标注
    set(sin_text, 'Position', [t(end), m_sin(end)], 'String', sprintf('%.2f', m_sin(end)));
    
    % 更新X轴范围
    x1 = x1 + 0.1;    
    axis(ax1, [x1 x1 + 2 * pi -1.5 1.5]);
    
    % 停止条件
    if i > 100000
        stop(timerSin);
        delete(timerSin);
    end
    i = i + 1;
end

% 定时器2的回调函数：更新余弦曲线
function updateCosPlot(ax2)
    global p_cos cos_text timerCos
    persistent j x2
    if isempty(j), j = 1; x2 = -1.5 * pi; end
    
    % 更新余弦曲线数据
    t = [p_cos.XData 0.01 * j];
    m_cos = [p_cos.YData cos(0.01 * j)];
    % 限制数据量：仅保留最近1000个点
    if length(t) > 1000
        t = t(end-999:end);
        m_cos = m_cos(end-999:end);
    end
    set(p_cos, 'XData', t, 'YData', m_cos);
    
    % 更新y值标注
    set(cos_text, 'Position', [t(end), m_cos(end)], 'String', sprintf('%.2f', m_cos(end)));
    
    % 更新X轴范围
    x2 = x2 + 0.01;    
    axis(ax2, [x2 x2 + 2 * pi -1.5 1.5]);
    
    % 停止条件
    if j > 100000
        stop(timerCos);
        delete(timerCos);
    end
    j = j + 1;
end





