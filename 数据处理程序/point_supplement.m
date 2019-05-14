%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function  [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate)
% 函数实现功能：
% 当某一次扫描,某条可靠航迹未获得更新点迹时
% 调用补点程序，给航迹补上点迹
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入宗量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trust_track --> 可靠航迹文件，存储已经形成的可靠航迹的新息
% track_data_output --> 该批次数据处理完毕后，输出的航迹信息，存储输出航迹信息的多行9列矩阵；各列代表含义如下：1距
% 离，2方位角,3俯仰角,4属于第几条航迹,5来/去,6积累时间,7是第几个点,8实点/补点，9属于哪个通道；
% ts --> 采样时间间隔
% time_accumulate --> 积累的时间，也即从第一批数据到此批处理数据之间所经过的时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入宗量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出宗量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trust_track --> 可靠航迹文件，存储已经形成的可靠航迹的新息
% 1-6列：每条航迹最后一个点的滤波信息，1距离，2距离向速度，3方位角,4方位角向速度，5俯仰角,6俯仰角速度
% 7-42列：滤波误差协方差信息，本是一个6*6的矩阵，存成行则变成36列
% 43航迹识别标志,44来/去,45是第几个点,46实点/补点,47属于哪个通道，48航迹未被更新次数，49更新标志0未更新/1更新，50航迹消亡的门%限值；
% track_data_output --> 该批次数据处理完毕后，输出的航迹信息，存储输出航迹信息的多行8列矩阵；各列代表含义如下：1距
% 离，2方位角,3俯仰角,4属于第几条航迹,5来/去,6积累时间,7是第几个点,8实点/补点，9属于哪个通道；
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出宗量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F=[1 ts 0 0 0 0;0 1 0 0 0 0;0 0 1 ts 0 0;0 0 0 1 0 0;0 0 0 0 1 ts;0 0 0 0 0 1];%状态矩阵
index_of_track = find(trust_track(:,49) == 0);  % 更新标志为0，即未被更新的航迹所在行
temp_num2=size(index_of_track,1);%得到未被更新航迹的数目
for i=1:temp_num2  %对所有未被更新的航迹进行补点，即采用kalman进行预测，用预测点对航迹进行更新  
    last_point= trust_track(index_of_track(i) ,1:6)';%航迹最后一个点的信息
    point_supple=F*last_point;%采用kalman进行预测，得到补点
    trust_track(index_of_track(i) ,1:6) = point_supple';%将补点更新航迹信息
    trust_track(index_of_track(i) ,45) = trust_track(index_of_track(i) ,45) + 1; % 航迹点数加1；
    trust_track(index_of_track(i) ,46) = 1;       % 补点标志为1
    trust_track(index_of_track(i) ,48) = trust_track(index_of_track(i) ,48) + 1;   % 航迹未用实点更新次数加1
    track_data_output=[track_data_output;point_supple(1),point_supple(3),point_supple(5),trust_track(index_of_track(i) ,43),...
        trust_track(index_of_track(i) ,44),time_accumulate,trust_track(index_of_track(i) ,45),...
        trust_track(index_of_track(i) ,46),trust_track(index_of_track(i) ,47)];%更新航迹信息
end

trust_track = sortrows(trust_track ,43);  % 按航迹标号重新排列
track_data_output = sortrows(track_data_output ,4);  % 按航迹标号重新排列