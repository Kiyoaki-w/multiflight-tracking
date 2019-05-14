%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function [state_initial,variance_initial] = kalman_filter_initial(first_point_of_track ,second_point_of_track ,ts ,...
    sigma_r,sigma_a,sigma_e)
% 函数实现功能：
% kalman滤波初始化程序，为后面的递推算法的实现，产生必需的初始化量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first_point_of_track --> 本航迹的第一个点,3*1的矩阵,第一行表示距离,第二行表示方位角，第三行表示俯仰角
% second_point_of_track --> 本航迹的第二个点
% ts --> 每两批数据之间的间隔时间
% sigma_r --> 距离观测噪声标准差
% sigma_a --> 方位角观测噪声标准差
% sigma_e --> 俯仰角观测噪声标准差
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% state_initial --> 初始状态
% variance_initial --> 初始协方差
%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%求初始状态%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
range_observe=[first_point_of_track(1),second_point_of_track(1)];
azimuth_observe=[first_point_of_track(2),second_point_of_track(2)];
elevation_observe=[first_point_of_track(3),second_point_of_track(3)];
Vr(2)=(range_observe(2)-range_observe(1))/ts;
Va(2)=(azimuth_observe(2)-azimuth_observe(1))/ts;
Ve(2)=(elevation_observe(2)-elevation_observe(1))/ts;
state_initial=[range_observe(2) Vr(2) azimuth_observe(2) Va(2) elevation_observe(2) Ve(2)]';%初始状态
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%求初始状态%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%求初始协方差%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
variance_initial=[sigma_r^2 sigma_r^2/ts 0 0 0 0;sigma_r^2/ts 2*sigma_r^2/ts^2 0 0 0 0;0 0 sigma_a^2 sigma_a^2/ts 0 0;...
    0 0 sigma_a^2/ts 2*sigma_a^2/ts^2 0 0;0 0 0 0 sigma_e^2 sigma_e^2/ts;0 0 0 0 sigma_e^2/ts 2*sigma_e^2/ts^2];%初始协方差
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%求初始协方差%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

