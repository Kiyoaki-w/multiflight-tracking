%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function  [track_data_output ,trust_track,temp_point, time_accumulate, number_of_track] = datatreat(track_data_output,range_vect,ci,ts,trust_track, temp_point, time_accumulate, number_of_track)
% 函数实现功能：对每次输入的点迹进行数据处理，包括航迹起始、点迹航迹关联、航迹补点、航迹消亡、剩余点迹删除等，形成可靠航迹输出

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_data_output --> 数据处理后,最终的输出，保存了所有航迹的所有点迹信息，为一多行9列矩阵:1距离，2方位角,3俯仰角,4属于第几条航迹,5来0/去1,6积累时间,7是第几个点,8实点0/补点1,9属于哪个通道
% range_vect --> 信号处理后得到的点迹信息，为多行4列矩阵：每一行的第一列为距离;第二列为方位角;第三列为俯仰角;第四列为通道号;
% ts --> 采样时间间隔
% ci --> 处理的是第几批数据
% trust_track --> 可靠航迹，保存每条可靠航迹的最后一个点的信息，为一多行50列矩阵
% 1-6列：每条航迹最后一个点的滤波信息，1距离，2距离向速度，3方位角,4方位角向速度，5俯仰角,6俯仰角速度
% 7-42列：滤波误差协方差信息，本是一个6*6的矩阵，存成行则变成36列
% 43航迹识别标志,44来/去,45是第几个点,46实点/补点,47属于哪个通道，48航迹未被更新次数，49更新标志0未更新/1更新，50航迹消亡的门限值；
% temp_point --> 暂时点迹文件，存储航迹起始和点迹航迹关联时没有用到的点迹，多行8列矩阵，1：距离；2：方位角；3：俯仰角；4：通道号；5：积累时间；
% 6：点迹未用次数；7：删除门限；8：已用/未用
% time_accumulate --> 积累的时间，也即从第一批数据到此批处理数据之间所经过的时间
% number_of_track  -->  已经形成的可靠航迹数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_data_output -->  数据处理后,最终的输出:1距离，2方位角,3俯仰角,4属于第几条航迹,5来0/去1,6积累时间,7是第几个点,8实点0/补点1,9属于哪个通道
% trust_track --> 可靠航迹，保存每条可靠航迹的最后一个点的信息，为一多行50列矩阵
% 1-6列：每条航迹最后一个点的滤波信息，1距离，2距离向速度，3方位角,4方位角向速度，5俯仰角,6俯仰角速度
% 7-42列：滤波误差协方差信息，本是一个6*6的矩阵，存成行则变成36列
% 43航迹识别标志,44来/去,45是第几个点,46实点/补点,47属于哪个通道，48航迹未被更新次数，49更新标志0未更新/1更新，50航迹消亡的门限值；
% temp_point --> 暂时点迹文件，存储航迹起始和点迹航迹关联时没有用到的点迹，多行8列矩阵，1：距离；2：方位角；3：俯仰角；4：通道号；5：积累时间；
% 6：点迹未用次数；7：删除门限；8：已用/未用
% time_accumulate --> 积累的时间，也即从第一批数据到此批处理数据之间所经过的时间
% number_of_track  -->  已经形成的可靠航迹数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输出变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


range_min = 300;   % 真实目标的滤波门限 ，即目标点迹的距离、方位角、俯仰角
range_max = 3600000;   % 满足该门限值时，可认为该目标为可靠点
azimuth_min = 0;%方位角门限值
azimuth_max = pi;%方位角门限值
elevation_min = 0;%俯仰角门限值
elevation_max = pi;%俯仰角门限值

ts=1;
% sigma_r=60;%这些值比较难取，不知道该怎么取,雷达数据处理第138页，sigma_r=0.1ct/2,c:光速；t：发射脉冲的宽度
% sigma_a=1/180*pi;%方位角和俯仰角是一样的，sigma_a=0.1B，B:天线波束宽度
% sigma_e=1/180*pi;
sigma_r=10;%目标距离的观测噪声标准差
sigma_a=1e-2;%目标方位角的观测噪声标准差
sigma_e=1e-2;%目标俯仰角的观测噪声标准差
sigma_ar=3;%目标距离的过程噪声标准差
sigma_aa=3;%目标方位角的过程噪声标准差
sigma_ae=3;%目标俯仰角的过程噪声标准差

K_start=100;%控制波门大小的参数
K_association=2;%这些值比较难取，不知道该怎么取


if (isempty(range_vect) == 0)     % 如果信号处理后的数据非空
    index = find ( range_vect(:,1) >= range_max | range_vect(:,1) <= range_min | ...          % 进行数据预处理，设置最基本的滤波门限,去除虚点
        range_vect(:,2) >= azimuth_max | range_vect(:,2) <= azimuth_min | ...  
        range_vect(:,3) >= elevation_max  | range_vect(:,3) <= elevation_min);
    range_vect(index,:) = [];                                                               % 将不符合要求的虚点虑除
    data_to_treat = range_vect;     % 将通过门限滤波后的数据存入存储器中,即输入数据
    if ( ci == 1 )                          % 如果处理的是第一批数据
        time_accumulate = ts;           % 时间积累
        if ( isempty ( data_to_treat ) == 1)    % 如果输入数据为空            
            temp_point = [];    % 所需数据初始化
            trust_track = [];
            track_data_output = [];
        elseif ( isempty ( data_to_treat ) == 0)   % 如果输入数据非空
            range_inform = data_to_treat(:,1);  % 提取距离,方位角,俯仰角,通道数等信息     
            azimuth_inform = data_to_treat(:,2);
            elevation_inform = data_to_treat(:,3);
            DBF_inform = data_to_treat(:,4);
            %gate_of_point_delete = 5;  % 点迹消除的门限次数 %ceil((gate_of_range/ts)./data_to_treat(:,2));3-9：在本程序中该方法不适用
            number_of_point = size (range_inform ,1); 
            gate_of_point_delete = repmat(5,number_of_point,1);% 点迹消除的门限次数：5
            number_of_unuse_point = ones(number_of_point ,1);%点迹未用次数
            time_accumulate_vect = ones(number_of_point ,1)*time_accumulate;%积累时间
            flag_of_loop = zeros(number_of_point ,1);  % 在航迹起始中，做已经查询的标志，0未查/1已查
            temp_point = [range_inform ,azimuth_inform ,elevation_inform ,DBF_inform ,time_accumulate_vect ,number_of_unuse_point , gate_of_point_delete ,flag_of_loop];         % 保存在暂时点迹中
            trust_track = [];
        end              
    elseif ( ci > 1)              % 如果处理数据不是第一批

        time_accumulate = time_accumulate + ts;  % 时间积累
        if ( isempty ( data_to_treat ) == 1)     % 如果输入数据为空            
            if ( isempty (temp_point) == 0 )       % 如果暂时点迹非空
                temp_point(:,6) = temp_point(:,6) + 1;   % 点迹未使用次数加一
                temp_point(find(temp_point(:,6) == temp_point(:,7)) ,:) = [];   % 如果点迹没被使用次数达到门限次数,则删除该点迹
            end 
            if(isempty(trust_track) == 0)   %  如果可靠航迹非空
                [trust_track,track_data_output,number_of_track] = track_die_out(trust_track ,track_data_output,number_of_track);%调用航迹消亡程序
                [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate);% 调用补点程序
            end
        elseif ( isempty ( data_to_treat ) == 0 )    % 如果输入数据非空            
            range_inform = data_to_treat(:,1);     % 提取距离,方位角,俯仰角,通道数等信息
            azimuth_inform = data_to_treat(:,2);
            elevation_inform = data_to_treat(:,3);
            DBF_inform = data_to_treat(:,4);

            number_of_point = size (range_inform ,1); 
            gate_of_point_delete = repmat(5,number_of_point,1);% 点迹消除的门限次数：5
            number_of_unuse_point = ones(number_of_point ,1);      % 暂时点迹中,点迹未被使用的次数
            time_accumulate_vect = ones(number_of_point ,1)*time_accumulate;%积累时间
            flag_of_loop = zeros(number_of_point ,1);         % 在航迹起始中，做已经查询的标志，0未查/1已查
            point_now = [range_inform ,azimuth_inform ,elevation_inform ,DBF_inform ,time_accumulate_vect ,number_of_unuse_point ,gate_of_point_delete ,flag_of_loop];   % 保存在待处理数据中  
            if (isempty ( trust_track ) == 0)  % 如果可靠航迹非空
                [trust_track ,point_now,track_data_output] = point_track_association_change(point_now ,trust_track ,track_data_output,...
    ts,K_association,time_accumulate);                 % 调用关联程序
                [trust_track,track_data_output,number_of_track] = track_die_out(trust_track ,track_data_output,number_of_track);%调用航迹消亡程序
                [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate); %调用补点程序                  % 调用补点程序
            end    
            if ( isempty (temp_point) == 1)     % 如果暂时点迹为空
                temp_point = point_now;               
            elseif ( isempty (temp_point) == 0 )  % 如果暂时点迹非空
                %　调用航迹开始程序
                [temp_point ,trust_track ,track_data_output ,number_of_track] = track_start(temp_point ,point_now ,trust_track ,...
    K_start ,time_accumulate ,ts ,sigma_r,sigma_a,sigma_e ,track_data_output ,number_of_track) ;
            end
        end  
    end
elseif ( isempty(range_vect ) == 1)   % 如果恒虚警处理后的数据为空
    if (ci == 1)
        time_accumulate = 0;           % 时间积累
        temp_point = [];
        trust_track = [];
    elseif (ci > 1)

        time_accumulate = time_accumulate + ts;
        if (isempty(temp_point) == 0)    % 如果暂时点迹非空
            temp_point(:,6) = temp_point(:,6) + 1;   % 点迹未使用次数加一
            temp_point(find(temp_point(:,6) == temp_point(:,7)) ,:) = [];   % 如果点迹没被使用次数达到门限次数,则删除该点迹
        end
        
        if (isempty(trust_track) == 0)  %   如果可靠航迹非空
            [trust_track,track_data_output,number_of_track] = track_die_out(trust_track ,track_data_output,number_of_track);%调用航迹消亡程序
            [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate);% 调用补点程序
        end
    end
end 


if (isempty(trust_track) == 0)

    trust_track(:,49) = 0; % 一批数据处理结束，所有航迹更新标志置0；
    trust_track = sortrows(trust_track ,43);  % 按航迹标号重新排列
    track_data_output = sortrows(track_data_output ,4);  % 按航迹标号重新排列
end

