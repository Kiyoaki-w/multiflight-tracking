%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)


close all;
clear all;
clc;
%%%主程序：首先产生6条航迹：直线航迹1、圆航迹、直线航迹2、直线航迹3、8字航迹、椭圆航迹，接着进行数据处理，并将结果进行显示
%%%程序中距离的单位为m，速度的单位为m/s，角度的单位为弧度
%%%程序中的通道号并未用到，故所有通道号都取1
%%%%%%%%%%%%%%%%%%%%%直线航迹1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=1;%一个CPI的时间
Rx0=1000;%目标在x轴上的起始距离,单位m
Ry0=1000;%目标在y轴上的起始距离
Rz0=1000;%目标在z轴上的起始距离
vx=50;%目标在x轴上的速度,单位m/s
vy=50;%目标在y轴上的速度
vz=50;%目标在z轴上的速度
sigma_r=10;%目标距离的观测噪声标准差
sigma_t=1e-2;%目标方位角的观测噪声标准差
sigma_p=1e-2;%目标俯仰角的观测噪声标准差
N=150;%共150个点，即共有150个CPI
%noise=randn(1,N);%用来产生高斯白噪声
load qq noise;%由于噪声的随机性，不便于调试，故将噪声保存在qq文件中，调用时load一下就行
for k=1:N
    tmp_Rx(k)=Rx0+vx*(k-1)*T;%目标在x轴上的真实运动轨迹
    tmp_Ry(k)=Ry0+vy*(k-1)*T;%目标在y轴上的真实运动轨迹
    tmp_Rz(k)=Rz0+vz*(k-1)*T;%目标在z轴上的真实运动轨迹
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%将目标运动轨迹转换为极坐标系下的值，目标的径向距离
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));%目标的俯仰角
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));%目标的方位角
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))%进行坐标系转换时需考虑象限的问题，当位于二三象限时，方位角需要加上一个pi
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%将目标的真实运动轨迹加上观测噪声，即目标的观测值
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
figure(2);%将数据处理前的航迹画出来
polar(theta_observe,R_xy_observe,'k.');
title('原始航迹');hold on;

DBF=ones(N,1);%代表通道号，本系统未用到，故所有通道号均取1
range_vect_line1=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%直线航迹1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%圆形航迹%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=1;%一个CPI的时间
Rx0=6000;%目标在x轴上的起始距离
Ry0=6000;%目标在y轴上的起始距离
Rz0=1000;%目标在z轴上的起始距离
v=100;%目标的速度
w=0.05;%目标的角速度，圆的半径=v/w
sigma_r=10;%目标距离的观测噪声标准差
sigma_t=1e-2;%目标方位角的观测噪声标准差
sigma_p=1e-2;%目标俯仰角的观测噪声标准差
for k=1:N
    tmp_Rx(k)=Rx0+v/w*cos(w*(k-1)*T);%目标在x轴上的真实运动轨迹
    tmp_Ry(k)=Ry0+v/w*sin(w*(k-1)*T);%目标在y轴上的真实运动轨迹
    tmp_Rz(k)=Rz0;%目标在z轴上的真实运动轨迹
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%将目标运动轨迹转换为极坐标系下的值，目标的径向距离
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));%目标的俯仰角
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));%目标的方位角
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))%进行坐标系转换时需考虑象限的问题，当位于二三象限时，方位角需要加上一个pi
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%将目标的真实运动轨迹加上观测噪声，即目标的观测值
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'ro');hold on;
DBF=ones(N,1);
range_vect_circle=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%圆形航迹%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%直线航迹2%%%%%%%%%%%%%%%%%%%%%直线航迹2和直线航迹3的设置与直线航迹1一样
Rx0=-1000;
Ry0=1000;
Rz0=1000;
vx=-50;
vy=50;
vz=50;
sigma_r=10;
sigma_t=1e-2;
sigma_p=1e-2;
for k=1:N
    tmp_Rx(k)=Rx0+vx*(k-1)*T;%目标在x轴上的真实运动轨迹
    tmp_Ry(k)=Ry0+vy*(k-1)*T;%目标在y轴上的真实运动轨迹
    tmp_Rz(k)=Rz0+vz*(k-1)*T;%目标在z轴上的真实运动轨迹
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end

Rr_observe=Rr+sigma_r*noise;
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'yx');hold on;
DBF=ones(N,1);
range_vect_line2=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%直线航迹2%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%直线航迹3%%%%%%%%%%%%%%%%%%%%%
Rx0=3000;
Ry0=1000;
Rz0=1000;
vx=-50;
vy=50;
vz=50;
sigma_r=10;
sigma_t=1e-2;
sigma_p=1e-2;
for k=1:N
    tmp_Rx(k)=Rx0+vx*(k-1)*T;%目标在x轴上的真实运动轨迹
    tmp_Ry(k)=Ry0+vy*(k-1)*T;%目标在y轴上的真实运动轨迹
    tmp_Rz(k)=Rz0+vz*(k-1)*T;%目标在z轴上的真实运动轨迹
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end

Rr_observe=Rr+sigma_r*noise;
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'g+');hold on;
DBF=ones(N,1);
range_vect_line3=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%直线航迹3%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%8字航迹%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma_r=10;%目标距离的观测噪声标准差
sigma_t=1e-2;%目标方位角的观测噪声标准差
sigma_p=1e-2;%目标俯仰角的观测噪声标准差
dist_8eye1=1000*sqrt(3);%一号圆心的距离
azimuth_8eye1=pi/4;%一号圆心的方位
dist_8eye2=1000*sqrt(3);%二号圆心的距离
azimuth_8eye2=pi/4*3;%二号圆心的方位
height=1000;%8字轨迹的高度
v=100;%目标运动速度
for k=1:150
    t=k-1;
    pt=EightTrack(dist_8eye1,azimuth_8eye1,dist_8eye2,azimuth_8eye2,height,v,t);%调用8字轨迹函数EightTrack，该8字形轨迹上t时刻的点的坐标pt 
    tmp_Rx(k)=pt(1);%得到目标直角坐标系下位置
    tmp_Ry(k)=pt(2);
    tmp_Rz(k)=pt(3);
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%转换为极坐标下的值
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%加上噪声得到观测值
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'b*');hold on;
DBF=ones(N,1);
range_vect_8=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%8字航迹%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%椭圆航迹%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma_r=10;%目标距离的观测噪声标准差
sigma_t=1e-2;%目标方位角的观测噪声标准差
sigma_p=1e-2;%目标俯仰角的观测噪声标准差
N=150;

dist_ellieye=5000*sqrt(3);%椭圆中心的距离
azimuth_ellieye=pi/4*3;%椭圆中心的方位
len_laxis=2000;%椭圆长轴的长度
len_saxis=1000;%椭圆短轴的长度
height=1000;%椭圆的高度
v=100;%目标运动速度
for k=1:150
    t=k-1;
    pt=EllipseTrack(dist_ellieye,azimuth_ellieye,len_laxis,len_saxis,height,v,t);%调用椭圆轨迹函数EllipseTrack，得到该椭圆轨迹上t时刻的点的坐标pt
    tmp_Rx(k)=pt(1);%得到目标直角坐标系下位置
    tmp_Ry(k)=pt(2);
    tmp_Rz(k)=pt(3);
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%转换为极坐标下的值
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%加上噪声得到观测值
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'cd');hold on;
DBF=ones(N,1);
range_vect_ell=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%椭圆航迹%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%虚假目标：噪声%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Rr_observe=10000+sigma_r*noise;%在距离向产生高斯白噪声
theta_observe=noise * pi ;%在方位角向产生高斯白噪声
phi_observe= noise * pi ;%在俯仰角向产生高斯白噪声
range_vect_noise=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%虚假目标：噪声%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ts=1;%一个CPI的时间长度
trust_track=[];
temp_point=[];
time_accumulate=0;
number_of_track=0;
track_data_output=[];
for ci=1:150
    %range_vect1=[range_vect_line(ci,:);range_vect_circle(ci,:);range_vect2(ci,:);range_vect3(ci,:)];
    if(ci==20| ci==100) %| ci==20 | ci==40 | ci==60 | ci==80 | ci==100)
        range_vect=[];%将第20和第100个CPI的值置空，相当于漏警，为了查看航迹能不能补点
    else
        range_vect=[range_vect_line1(ci,:);range_vect_circle(ci,:);range_vect_line2(ci,:);range_vect_line3(ci,:);range_vect_8(ci,:);range_vect_ell(ci,:)...
        ;range_vect_noise(ci,:)];%每个CPI信号处理都得到的点迹信息
    end
%     FilePath = 'E:\data_treat';
%     [range_vect] = file_save(FilePath,ci,time_accumulate+1,range_vect);
    [track_data_output ,trust_track,temp_point, time_accumulate, number_of_track] = datatreat(track_data_output,range_vect,ci,ts,trust_track,...
        temp_point, time_accumulate, number_of_track);%数据处理主函数
    draw_track(track_data_output , number_of_track);%航迹显示

end
