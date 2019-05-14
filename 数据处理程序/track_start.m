%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function [temp_point ,trust_track ,track_data_output ,number_of_track] = track_start(temp_point ,point_now ,trust_track ,...
    K_start ,time_accumulate ,ts ,sigma_r,sigma_a,sigma_e ,track_data_output ,number_of_track) 
% 函数实现功能：
% 采用滑窗法，将满足一定要求的两个点关联成一条航迹
% 如果一点跟暂时点迹中的点关联上了，则它不能再跟其他的点关联
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temp_point --> 暂时点迹文件，存储航迹起始和点迹航迹关联时没有用到的点迹
% point_now --> 每次从CFAR处理后来的点迹，经过基本门限滤波后剩余点迹，存储在缓冲区中
% trust_track --> 可靠航迹文件，存储已经形成的可靠航迹的信息
% K_start --> 可调参数，用于调整航迹起始波门的大小
% time_accumulate --> 积累的时间，也即从第一批数据到此批处理数据之间所经过的时间
% ts --> 每两批数据之间的间隔时间
% sigma_r --> 距离观测噪声标准差
% sigma_a --> 方位角观测噪声标准差
% sigma_e --> 俯仰角观测噪声标准差
% track_data_output --> 该批次数据处理完毕后，输出的航迹信息
% number_of_track --> 已经形成的航迹数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temp_point --> 暂时点迹文件，存储航迹起始和点迹航迹关联时没有用到的点迹,多行8列矩阵，1：距离；2：方位角；3：俯仰角；4：通道号；5：积累时间；
% 6：点迹未用次数；7：删除门限；8：已用/未用
% trust_track --> 可靠航迹文件，存储已经形成的可靠航迹的信息，存储可靠航迹信息的多行50列矩阵，用来保存每条可靠航迹的最后
% 一个点的信息，各列意义分别是：
% 1-6列：每条航迹最后一个点的滤波信息，1距离，2距离向速度，3方位角,4方位角向速度，5俯仰角,6俯仰角速度
% 7-42列：滤波误差协方差信息，本是一个6*6的矩阵，存成行则变成36列
% 43航迹识别标志,44来/去,45是第几个点,46实点/补点,47属于哪个通道，48航迹未被更新次数，49更新标志0未更新/1更新，50航迹消亡的门限值；
% track_data_output --> 该批次数据处理完毕后，输出的航迹信息，存储输出航迹信息的多行9列矩阵；各列代表含义如下：1距
% 离，2方位角,3俯仰角,4属于第几条航迹,5来/去,6积累时间,7是第几个点,8实点/补点，9属于哪个通道；

% number_of_track --> 已经形成的航迹数

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_of_point = 1 ; %   是该航迹中的第一点
flag_of_come_go = 0;  %   0来/1去标志
flag_of_ture_void = 0;%   0实点/1虚点标志`
flat_of_renew = 0;    %   航迹更新标志 0未更新/1更新
number_of_unrenew = 0;%   航迹未被更新次数
for  loop_of_now = 1:size(point_now ,1)
    for loop_of_pre = 1:size(temp_point ,1)
        if(temp_point(loop_of_pre,8) == 0 & point_now(loop_of_now,8) == 0) % 如果该点没被查询
%             range_gate_of_start=0.5*K_start*sqrt(sigma_r^2*ts^2+2*sigma_r^2);
%             azimuth_gate_of_start=0.5*K_start*sqrt(sigma_a^2*ts^2+2*sigma_a^2);
%             elevation_gate_of_start=0.5*K_start*sqrt(sigma_e^2*ts^2+2*sigma_e^2);
            range_gate_of_start=100;%航迹起始中波门大小
            azimuth_gate_of_start=0.1;%航迹起始中波门大小
            elevation_gate_of_start=0.1;%航迹起始中波门大小
            %航迹起始采用2/2逻辑，两个点关联就形成可靠航迹
            if(abs(point_now(loop_of_now,1) - temp_point(loop_of_pre,1)) <= range_gate_of_start & ...   % 暂时点迹中的点和输入的点满足门限
                    abs(point_now(loop_of_now ,2) - temp_point(loop_of_pre,2)) <= azimuth_gate_of_start & ... 
                    abs(point_now(loop_of_now ,3) - temp_point(loop_of_pre,3)) <= elevation_gate_of_start )   
                temp_point(loop_of_pre,8) = 1;     % 暂时点迹中该点已被使用
                point_now(loop_of_now,8) = 1;  % 输入信息中该点已被使用
                first_point_of_track = [temp_point(loop_of_pre,1);temp_point(loop_of_pre,2);temp_point(loop_of_pre,3)];  % 存储该航迹的第一点
                second_point_of_track = [point_now(loop_of_now,1);point_now(loop_of_now,2);point_now(loop_of_now,3)];   % 存储该航迹的第二点
                [state_initial,variance_initial] = kalman_filter_initial(first_point_of_track ,second_point_of_track ,ts ,...
                                                                      sigma_r,sigma_a,sigma_e);  % 调用卡尔曼滤波器初始化程序
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%本程序中目标运动方向无用%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                if (point_now(loop_of_now,1) - temp_point(loop_of_pre,1) > 0)  % 第一列代表距离 判断飞行物的来去方向
                    flag_of_come_go = 1;
                elseif (point_now(loop_of_now,1) - temp_point(loop_of_pre,1) < 0)
                    flag_of_come_go = 0;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%本程序中目标运动方向无用%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                number_of_track = number_of_track + 1;   % 形成的可靠航迹数加1    
                if (isempty (trust_track) == 1)            % 如果可靠航迹为空，trust_track和非空时有区别
                    track_data_output = [track_data_output;temp_point(loop_of_pre,1) ,temp_point(loop_of_pre,2) ,temp_point(loop_of_pre,3) ,...
                            number_of_track ,flag_of_come_go ,temp_point(loop_of_pre,5),number_of_point ,...
                            flag_of_ture_void ,point_now(loop_of_now,4)];         %  输出该航迹的第一个点
                    track_data_output = [track_data_output;point_now(loop_of_now,1) ,point_now(loop_of_now ,2) ,point_now(loop_of_now,3) ,...
                            number_of_track ,flag_of_come_go ,point_now(loop_of_now ,5) ,number_of_point + 1 ,...
                            flag_of_ture_void ,point_now(loop_of_now,4)];        %  输出该航迹的第二点
                    trust_track(1,1:6) = state_initial';   
                    for i=1:6
                        trust_track(1,1+i*6:6+i*6)=variance_initial(i,:);
                    end

                    trust_track(1,43) = number_of_track;
                    trust_track(1,44) = flag_of_come_go;
                    trust_track(1,45) = number_of_point + 1;
                    trust_track(1,46) = flag_of_ture_void;
                    trust_track(1,47) = point_now(loop_of_now ,4);
                    trust_track(1,48) = number_of_unrenew;
                    trust_track(1,49) = flat_of_renew;
                    trust_track(1,50) = point_now(loop_of_now ,7); % 存储该航迹的信息
                                      
                elseif (isempty (trust_track) == 0)       % 如果可靠航迹非空
                    track_data_output = [track_data_output;temp_point(loop_of_pre,1) ,temp_point(loop_of_pre,2) ,temp_point(loop_of_pre,3) ,...
                            number_of_track ,flag_of_come_go ,temp_point(loop_of_pre,5) ,number_of_point ,...
                            flag_of_ture_void ,point_now(loop_of_now ,4)];               %  输出该航迹的第一个点
                    track_data_output = [ track_data_output; point_now(loop_of_now ,1) ,point_now(loop_of_now ,2) ,point_now(loop_of_now,3) ,...
                            number_of_track ,flag_of_come_go ,point_now(loop_of_now ,5) ,number_of_point + 1 ,...
                            flag_of_ture_void ,point_now(loop_of_now,4)];                %  输出该航迹的第二点
                    
                    trust_track  = [trust_track;state_initial',variance_initial(1,:),variance_initial(2,:),variance_initial(3,:),...
                        variance_initial(4,:),variance_initial(5,:),variance_initial(6,:),number_of_track,flag_of_come_go,number_of_point + 1,...
                        flag_of_ture_void,point_now(loop_of_now ,4),number_of_unrenew,flat_of_renew,point_now(loop_of_now ,7)];  %更新航迹信息                    
                end 
            end
        end
    end
end
point_now(find(point_now(: ,8) == 1),:) = [];    % 删除输入信息中已经使用过的点迹，第八列标志位=0的即未关联上的点迹存入暂时点迹文件中
temp_point(find(temp_point(:,8) == 1),:) = [];            % 删除暂时点迹中已经使用过的点迹
if (isempty(temp_point) == 0) % 如果暂时点迹中还有点迹
    temp_point(: ,6) = temp_point(: ,6) + 1;   % 点迹未使用次数加一
    temp_point(find(temp_point(: ,6) == temp_point(: ,7)),:) = [];   % 如果点迹没被使用次数达到门限值,则删除该点迹
end
temp_point = [temp_point;point_now];     %   将输入信息中未关联上的点迹存入暂时点迹文件中