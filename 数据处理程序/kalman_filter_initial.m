%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function [state_initial,variance_initial] = kalman_filter_initial(first_point_of_track ,second_point_of_track ,ts ,...
    sigma_r,sigma_a,sigma_e)
% ����ʵ�ֹ��ܣ�
% kalman�˲���ʼ������Ϊ����ĵ����㷨��ʵ�֣���������ĳ�ʼ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first_point_of_track --> �������ĵ�һ����,3*1�ľ���,��һ�б�ʾ����,�ڶ��б�ʾ��λ�ǣ������б�ʾ������
% second_point_of_track --> �������ĵڶ�����
% ts --> ÿ��������֮��ļ��ʱ��
% sigma_r --> ����۲�������׼��
% sigma_a --> ��λ�ǹ۲�������׼��
% sigma_e --> �����ǹ۲�������׼��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% state_initial --> ��ʼ״̬
% variance_initial --> ��ʼЭ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ʼ״̬%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
range_observe=[first_point_of_track(1),second_point_of_track(1)];
azimuth_observe=[first_point_of_track(2),second_point_of_track(2)];
elevation_observe=[first_point_of_track(3),second_point_of_track(3)];
Vr(2)=(range_observe(2)-range_observe(1))/ts;
Va(2)=(azimuth_observe(2)-azimuth_observe(1))/ts;
Ve(2)=(elevation_observe(2)-elevation_observe(1))/ts;
state_initial=[range_observe(2) Vr(2) azimuth_observe(2) Va(2) elevation_observe(2) Ve(2)]';%��ʼ״̬
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ʼ״̬%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ʼЭ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
variance_initial=[sigma_r^2 sigma_r^2/ts 0 0 0 0;sigma_r^2/ts 2*sigma_r^2/ts^2 0 0 0 0;0 0 sigma_a^2 sigma_a^2/ts 0 0;...
    0 0 sigma_a^2/ts 2*sigma_a^2/ts^2 0 0;0 0 0 0 sigma_e^2 sigma_e^2/ts;0 0 0 0 sigma_e^2/ts 2*sigma_e^2/ts^2];%��ʼЭ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ʼЭ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

