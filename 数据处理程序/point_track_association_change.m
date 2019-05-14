%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function [trust_track ,point_now,track_data_output] = point_track_association_change(point_now ,trust_track ,track_data_output,...
    ts,K_association,time_accumulate)

% 函数实现功能：
% 点迹可靠航迹关联程序
% 输入数据与可靠航迹关联,能够关联上的,更新可靠航迹
% 否则,存入暂时航迹文件,用于航迹起始,或者最后成为噪声
% 采用最近邻关联法，即将所有关联上的点的信息进行存储，计算两点间的统计间隔，采用查找法找出统计间隔最小的点迹与航迹，该点迹滤波之后更新该条航迹
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% point_now --> 每次从CFAR处理后来的点迹，经过基本门限滤波后剩余点迹，存储在缓冲区中
% trust_track --> 可靠航迹文件，存储已经形成的可靠航迹的新息
%1-6列：每条航迹最后一个点的滤波信息，1距离，2距离向速度，3方位角,4方位角向速度，5俯仰角,6俯仰角速度
%7-42列：滤波协方差信息，本是一个6*6的矩阵，存成行则变成36列
%43航迹识别标志,44来/去,45是第几个点,46实点/补点,47属于哪个通道，48航迹未被更新次数，49更新标志0未更新/1更新，50航迹消亡的门
%限值；
% range_gate_of_association --> 点迹航迹关联中的距离门限
% azimuth_gate_of_association --> 点迹航迹关联中的方位角门限
% elevation_gate_of_association --> 点迹航迹关联中的俯仰角门限
% K_association --> 一个可供选择的参数，用来调节波门大小
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% point_now --> 每次从CFAR处理后来的点迹，经过基本门限滤波后剩余点迹，存储在缓冲区中
% trust_track --> 可靠航迹文件，存储已经形成的可靠航迹的新息
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
statistical_distance=[];
F=[1 ts 0 0 0 0;0 1 0 0 0 0;0 0 1 ts 0 0;0 0 0 1 0 0;0 0 0 0 1 ts;0 0 0 0 0 1];
I=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1];
G=[ts^2/2 0 0;ts 0 0;0 ts^2/2 0;0 ts 0;0 0 ts^2/2;0 0 ts];
H=[1 0 0 0 0 0 ;0 0 1 0 0 0;0 0 0 0 1 0];
% sigma_r=60;
% sigma_a=1/180*pi;
% sigma_e=1/180*pi;
sigma_r=10;
sigma_a=1e-2;
sigma_e=1e-2;

sigma_ar=3;
sigma_aa=3;
sigma_ae=3;
Q=[sigma_ar^2 0 0;0 sigma_aa^2 0;0 0 sigma_ae^2];%过程噪声协方差
R_noise=[sigma_r^2 0 0;0 sigma_a^2 0;0 0 sigma_e^2];%观测噪声协方差
for loop_of_trust_track = 1:size(trust_track ,1)
    for loop_of_point = 1:size(point_now ,1)
        
            state_filter_last= trust_track(loop_of_trust_track,1:6)';
            state_filter_predict=F*state_filter_last;%用航迹上的最后一个点预测下一点的位置
            for i=1:6
                filter_variance_last(i,:)=trust_track(loop_of_trust_track,1+i*6:6+i*6);
            end
            filter_variance_predict=F*filter_variance_last*F'+G*Q*G';           %%%预测误差方差
            sigma_r_predict=filter_variance_predict(1,1);
            sigma_a_predict=filter_variance_predict(3,3);
            sigma_e_predict=filter_variance_predict(5,5);
            range_gate_of_association = K_association*sqrt(sigma_r^2+sigma_r_predict^2+ts^4/4*sigma_ar^2);% 点迹航迹关联中的距离门限
            azimuth_gate_of_association = K_association*sqrt(sigma_a^2+sigma_a_predict^2+ts^4/4*sigma_aa^2);%点迹航迹关联中的方位角门限
            elevation_gate_of_association = K_association*sqrt(sigma_e^2+sigma_e_predict^2+ts^4/4*sigma_ae^2);%点迹航迹关联中的俯仰角门限
            if (abs(state_filter_predict(1,1) - point_now(loop_of_point ,1))<= range_gate_of_association & ...
                    abs(state_filter_predict(3,1) - point_now(loop_of_point ,2))<= azimuth_gate_of_association &...
                    abs(state_filter_predict(5,1) - point_now(loop_of_point ,3))<= elevation_gate_of_association)
                %point_now(loop_of_point ,8) = 1;%相关成功，下面对相关上的点进行滤波
                S=H*filter_variance_predict*H'+R_noise;
                z=point_now(loop_of_point,1:3)';
                z_predict=[state_filter_predict(1,1),state_filter_predict(3,1),state_filter_predict(5,1)]';
                d=(z-z_predict)'*S^(-1)*(z-z_predict);%计算关联上的两个点之间的统计间隔
                statistical_distance=[statistical_distance;loop_of_trust_track,loop_of_point,d];%存放了所有关联上的点之间的统计间隔，为一多行3列矩阵，1航迹的序号，2点迹的序号，3统计间隔
                
%                 state_view=point_now(loop_of_point ,1:3)';
%                 %%%%%%%%%%%%%%%%滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 
%                 Kalman_gain=filter_variance_predict*H'*[H*filter_variance_predict*H'+R_noise]^(-1);          %%%%增益
% 
%                 filter_variance=[I-Kalman_gain*H]*filter_variance_predict;         %%%%滤波误差方差
% 
%                 state_filter=state_filter_predict+Kalman_gain*[state_view-H*state_filter_predict];     %%%%滤波估计
%                 %%%%%%%%%%%%%%%%%滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 trust_track(loop_of_trust_track ,1:6) = state_filter';   %  最后一个点的状态更新
%                 for i=1:6
%                     trust_track(loop_of_trust_track,1+i*6:6+i*6)=filter_variance(i,:);
%                 end
%                  
%                 trust_track(loop_of_trust_track ,45) =  trust_track(loop_of_trust_track ,45) + 1;    % 可靠航迹点数加一
%                 trust_track(loop_of_trust_track ,46) = 0;      %  实/补点标志，实点为0，补点为1
%                 trust_track(loop_of_trust_track ,48) = 0;      %  未用实点更新次数置0;
%                 trust_track(loop_of_trust_track ,49) = 1;     %  更新标志置1
%                 trust_track (loop_of_trust_track ,50) = point_now(loop_of_point ,7) ;     % 更新航迹消亡的门限次数
%                 if(trust_track(loop_of_trust_track ,45) > 2 )     %   如果不是刚起始的航迹,输出
%                     track_data_output = [track_data_output;state_filter(1,1) ,state_filter(3,1),state_filter(5,1),...           
%                                    trust_track(loop_of_trust_track ,43),trust_track(loop_of_trust_track ,44),...
%                                    time_accumulate,trust_track(loop_of_trust_track ,45),trust_track(loop_of_trust_track ,46),trust_track(loop_of_trust_track ,47)];
%                 end 
            end
        %end
    end     
end
for i=1:size(trust_track ,1)%%寻找统计间隔矩阵中统计间隔最小的
    if(isempty(statistical_distance) == 0)
        min_data=min(statistical_distance(:,3));
        min_x=find(statistical_distance(:,3)==min_data);
        
        
        track_num=statistical_distance(min_x(1),1);
        point_num=statistical_distance(min_x(1),2);
        point_now(point_num ,8) = 1;
        state_view=point_now(point_num ,1:3)';
        state_filter_last= trust_track(track_num,1:6)';
        state_filter_predict=F*state_filter_last;%用航迹上的最后一个点预测下一点的位置
        for i=1:6
            filter_variance_last(i,:)=trust_track(track_num,1+i*6:6+i*6);
        end
        filter_variance_predict=F*filter_variance_last*F'+G*Q*G';           %%%预测误差方差
        %%%%%%%%%%%%%%%滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

        Kalman_gain=filter_variance_predict*H'*[H*filter_variance_predict*H'+R_noise]^(-1);          %%%%增益

        filter_variance=[I-Kalman_gain*H]*filter_variance_predict;         %%%%滤波误差方差

        state_filter=state_filter_predict+Kalman_gain*[state_view-H*state_filter_predict];     %%%%滤波估计
        %%%%%%%%%%%%%%%%%滤波%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        trust_track(track_num ,1:6) = state_filter';   %  最后一个点的状态更新
        for i=1:6
            trust_track(track_num,1+i*6:6+i*6)=filter_variance(i,:);
        end

        trust_track(track_num ,45) =  trust_track(track_num ,45) + 1;    % 可靠航迹点数加一
        trust_track(track_num ,46) = 0;      %  实/补点标志，实点为0，补点为1
        trust_track(track_num ,48) = 0;      %  未用实点更新次数置0;
        trust_track(track_num ,49) = 1;     %  更新标志置1
        trust_track (track_num ,50) = point_now(point_num ,7) ;     % 更新航迹消亡的门限次数
        if(trust_track(track_num ,45) > 2 & trust_track(track_num ,49) == 1)     %   如果不是刚起始的航迹,输出
            track_data_output = [track_data_output;state_filter(1,1) ,state_filter(3,1),state_filter(5,1),...           
                           trust_track(track_num ,43),trust_track(track_num ,44),...
                           time_accumulate,trust_track(track_num ,45),trust_track(track_num ,46),trust_track(track_num ,47)];
        end 
        statistical_distance(find(statistical_distance(:,1)==track_num),:)=[];%将该条航迹的所有信息删除
        statistical_distance(find(statistical_distance(:,2)==point_num),:)=[];%将该点迹的所有信息删除
    end
end
point_now(find(point_now(:,8) == 1) ,:) = [];  % 删除跟可靠航迹关联上的点迹
track_data_output = sortrows(track_data_output,4);     % 按照航迹标号排序