% 圆心和半径
radius = 600;
centerX = -600;
centerY = 0;

% 初始化存储点的数组
points = zeros(24, 2);

% 生成24个点，每隔15度一个点
for i = 0:23
    theta = deg2rad(i * 15); % 将角度转换为弧度
    x = centerX + radius * cos(theta);
    y = centerY + radius * sin(theta);
    points(i + 1, :) = [x, y];
end

% 输出24个点
disp(points);
