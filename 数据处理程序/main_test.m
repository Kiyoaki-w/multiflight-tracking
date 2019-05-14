%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)


close all;
clear all;
clc;
%%%���������Ȳ���6��������ֱ�ߺ���1��Բ������ֱ�ߺ���2��ֱ�ߺ���3��8�ֺ�������Բ���������Ž������ݴ����������������ʾ
%%%�����о���ĵ�λΪm���ٶȵĵ�λΪm/s���Ƕȵĵ�λΪ����
%%%�����е�ͨ���Ų�δ�õ���������ͨ���Ŷ�ȡ1
%%%%%%%%%%%%%%%%%%%%%ֱ�ߺ���1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=1;%һ��CPI��ʱ��
Rx0=1000;%Ŀ����x���ϵ���ʼ����,��λm
Ry0=1000;%Ŀ����y���ϵ���ʼ����
Rz0=1000;%Ŀ����z���ϵ���ʼ����
vx=50;%Ŀ����x���ϵ��ٶ�,��λm/s
vy=50;%Ŀ����y���ϵ��ٶ�
vz=50;%Ŀ����z���ϵ��ٶ�
sigma_r=10;%Ŀ�����Ĺ۲�������׼��
sigma_t=1e-2;%Ŀ�귽λ�ǵĹ۲�������׼��
sigma_p=1e-2;%Ŀ�긩���ǵĹ۲�������׼��
N=150;%��150���㣬������150��CPI
%noise=randn(1,N);%����������˹������
load qq noise;%��������������ԣ������ڵ��ԣ��ʽ�����������qq�ļ��У�����ʱloadһ�¾���
for k=1:N
    tmp_Rx(k)=Rx0+vx*(k-1)*T;%Ŀ����x���ϵ���ʵ�˶��켣
    tmp_Ry(k)=Ry0+vy*(k-1)*T;%Ŀ����y���ϵ���ʵ�˶��켣
    tmp_Rz(k)=Rz0+vz*(k-1)*T;%Ŀ����z���ϵ���ʵ�˶��켣
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%��Ŀ���˶��켣ת��Ϊ������ϵ�µ�ֵ��Ŀ��ľ������
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));%Ŀ��ĸ�����
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));%Ŀ��ķ�λ��
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))%��������ϵת��ʱ�迼�����޵����⣬��λ�ڶ�������ʱ����λ����Ҫ����һ��pi
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%��Ŀ�����ʵ�˶��켣���Ϲ۲���������Ŀ��Ĺ۲�ֵ
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
figure(2);%�����ݴ���ǰ�ĺ���������
polar(theta_observe,R_xy_observe,'k.');
title('ԭʼ����');hold on;

DBF=ones(N,1);%����ͨ���ţ���ϵͳδ�õ���������ͨ���ž�ȡ1
range_vect_line1=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%ֱ�ߺ���1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%Բ�κ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=1;%һ��CPI��ʱ��
Rx0=6000;%Ŀ����x���ϵ���ʼ����
Ry0=6000;%Ŀ����y���ϵ���ʼ����
Rz0=1000;%Ŀ����z���ϵ���ʼ����
v=100;%Ŀ����ٶ�
w=0.05;%Ŀ��Ľ��ٶȣ�Բ�İ뾶=v/w
sigma_r=10;%Ŀ�����Ĺ۲�������׼��
sigma_t=1e-2;%Ŀ�귽λ�ǵĹ۲�������׼��
sigma_p=1e-2;%Ŀ�긩���ǵĹ۲�������׼��
for k=1:N
    tmp_Rx(k)=Rx0+v/w*cos(w*(k-1)*T);%Ŀ����x���ϵ���ʵ�˶��켣
    tmp_Ry(k)=Ry0+v/w*sin(w*(k-1)*T);%Ŀ����y���ϵ���ʵ�˶��켣
    tmp_Rz(k)=Rz0;%Ŀ����z���ϵ���ʵ�˶��켣
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%��Ŀ���˶��켣ת��Ϊ������ϵ�µ�ֵ��Ŀ��ľ������
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));%Ŀ��ĸ�����
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));%Ŀ��ķ�λ��
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))%��������ϵת��ʱ�迼�����޵����⣬��λ�ڶ�������ʱ����λ����Ҫ����һ��pi
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%��Ŀ�����ʵ�˶��켣���Ϲ۲���������Ŀ��Ĺ۲�ֵ
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'ro');hold on;
DBF=ones(N,1);
range_vect_circle=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%Բ�κ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%ֱ�ߺ���2%%%%%%%%%%%%%%%%%%%%%ֱ�ߺ���2��ֱ�ߺ���3��������ֱ�ߺ���1һ��
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
    tmp_Rx(k)=Rx0+vx*(k-1)*T;%Ŀ����x���ϵ���ʵ�˶��켣
    tmp_Ry(k)=Ry0+vy*(k-1)*T;%Ŀ����y���ϵ���ʵ�˶��켣
    tmp_Rz(k)=Rz0+vz*(k-1)*T;%Ŀ����z���ϵ���ʵ�˶��켣
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
%%%%%%%%%%%%%%%%%ֱ�ߺ���2%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%ֱ�ߺ���3%%%%%%%%%%%%%%%%%%%%%
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
    tmp_Rx(k)=Rx0+vx*(k-1)*T;%Ŀ����x���ϵ���ʵ�˶��켣
    tmp_Ry(k)=Ry0+vy*(k-1)*T;%Ŀ����y���ϵ���ʵ�˶��켣
    tmp_Rz(k)=Rz0+vz*(k-1)*T;%Ŀ����z���ϵ���ʵ�˶��켣
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
%%%%%%%%%%%%%%%%%ֱ�ߺ���3%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%8�ֺ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma_r=10;%Ŀ�����Ĺ۲�������׼��
sigma_t=1e-2;%Ŀ�귽λ�ǵĹ۲�������׼��
sigma_p=1e-2;%Ŀ�긩���ǵĹ۲�������׼��
dist_8eye1=1000*sqrt(3);%һ��Բ�ĵľ���
azimuth_8eye1=pi/4;%һ��Բ�ĵķ�λ
dist_8eye2=1000*sqrt(3);%����Բ�ĵľ���
azimuth_8eye2=pi/4*3;%����Բ�ĵķ�λ
height=1000;%8�ֹ켣�ĸ߶�
v=100;%Ŀ���˶��ٶ�
for k=1:150
    t=k-1;
    pt=EightTrack(dist_8eye1,azimuth_8eye1,dist_8eye2,azimuth_8eye2,height,v,t);%����8�ֹ켣����EightTrack����8���ι켣��tʱ�̵ĵ������pt 
    tmp_Rx(k)=pt(1);%�õ�Ŀ��ֱ������ϵ��λ��
    tmp_Ry(k)=pt(2);
    tmp_Rz(k)=pt(3);
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%ת��Ϊ�������µ�ֵ
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%���������õ��۲�ֵ
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'b*');hold on;
DBF=ones(N,1);
range_vect_8=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%8�ֺ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%��Բ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma_r=10;%Ŀ�����Ĺ۲�������׼��
sigma_t=1e-2;%Ŀ�귽λ�ǵĹ۲�������׼��
sigma_p=1e-2;%Ŀ�긩���ǵĹ۲�������׼��
N=150;

dist_ellieye=5000*sqrt(3);%��Բ���ĵľ���
azimuth_ellieye=pi/4*3;%��Բ���ĵķ�λ
len_laxis=2000;%��Բ����ĳ���
len_saxis=1000;%��Բ����ĳ���
height=1000;%��Բ�ĸ߶�
v=100;%Ŀ���˶��ٶ�
for k=1:150
    t=k-1;
    pt=EllipseTrack(dist_ellieye,azimuth_ellieye,len_laxis,len_saxis,height,v,t);%������Բ�켣����EllipseTrack���õ�����Բ�켣��tʱ�̵ĵ������pt
    tmp_Rx(k)=pt(1);%�õ�Ŀ��ֱ������ϵ��λ��
    tmp_Ry(k)=pt(2);
    tmp_Rz(k)=pt(3);
    Rr(k)=sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2+tmp_Rz(k)^2);%ת��Ϊ�������µ�ֵ
    phi(k)=atan(tmp_Rz(k)/sqrt(tmp_Rx(k)^2+tmp_Ry(k)^2));
    theta(k)=atan(tmp_Ry(k)/tmp_Rx(k));
    if((tmp_Rx(k)>=0 & tmp_Ry(k)>=0) | (tmp_Rx(k)>=0 & tmp_Ry(k)<0))
        theta(k)=theta(k);
    else theta(k)=theta(k)+pi;
    end
end
Rr_observe=Rr+sigma_r*noise;%���������õ��۲�ֵ
theta_observe=theta+sigma_t*noise;
phi_observe=phi+sigma_p*noise;
R_xy_observe=Rr_observe.*abs(cos(phi_observe));
polar(theta_observe,R_xy_observe,'cd');hold on;
DBF=ones(N,1);
range_vect_ell=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%��Բ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%���Ŀ�꣺����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Rr_observe=10000+sigma_r*noise;%�ھ����������˹������
theta_observe=noise * pi ;%�ڷ�λ���������˹������
phi_observe= noise * pi ;%�ڸ������������˹������
range_vect_noise=[Rr_observe',theta_observe',phi_observe',DBF];
%%%%%%%%%%%%%%%%%%%%%���Ŀ�꣺����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ts=1;%һ��CPI��ʱ�䳤��
trust_track=[];
temp_point=[];
time_accumulate=0;
number_of_track=0;
track_data_output=[];
for ci=1:150
    %range_vect1=[range_vect_line(ci,:);range_vect_circle(ci,:);range_vect2(ci,:);range_vect3(ci,:)];
    if(ci==20| ci==100) %| ci==20 | ci==40 | ci==60 | ci==80 | ci==100)
        range_vect=[];%����20�͵�100��CPI��ֵ�ÿգ��൱��©����Ϊ�˲鿴�����ܲ��ܲ���
    else
        range_vect=[range_vect_line1(ci,:);range_vect_circle(ci,:);range_vect_line2(ci,:);range_vect_line3(ci,:);range_vect_8(ci,:);range_vect_ell(ci,:)...
        ;range_vect_noise(ci,:)];%ÿ��CPI�źŴ����õ��ĵ㼣��Ϣ
    end
%     FilePath = 'E:\data_treat';
%     [range_vect] = file_save(FilePath,ci,time_accumulate+1,range_vect);
    [track_data_output ,trust_track,temp_point, time_accumulate, number_of_track] = datatreat(track_data_output,range_vect,ci,ts,trust_track,...
        temp_point, time_accumulate, number_of_track);%���ݴ���������
    draw_track(track_data_output , number_of_track);%������ʾ

end
