%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function pt=EightTrack(dist_8eye1,azimuth_8eye1,dist_8eye2,azimuth_8eye2,height,v,t)
% EightTrack():8���κ�����ʵ��
%���� :����̨���в���,��8���ζ���
%      һ��Բ�ĵľ���dist_8eye1�ͷ�λazimuth_8eye1������Բ�ĵľ���dist_8eye2�ͷ�λazimuth_8eye2���߶�height���ٶ�v����ǰʱ��t
%�������8���ι켣��tʱ�̵ĵ������pt 

Ra=sqrt(dist_8eye1^2-height^2);thi_a=azimuth_8eye1;%һ��Բ��ͶӰ��XOYƽ���ϵľ������ͷ�λ
Rb=sqrt(dist_8eye2^2-height^2);thi_b=azimuth_8eye2;%����Բ��ͶӰ��XOYƽ���ϵľ������ͷ�λ
z=height;%�߶�
r=sqrt(Ra^2+Rb^2-2*Ra*Rb*cos(thi_a-thi_b))/2;%�뾶
pa=[Ra.*cos(thi_a) Ra.*sin(thi_a) z];%Բ��pa����
pb=[Rb.*cos(thi_b) Rb.*sin(thi_b) z];%Բ��pb����
pf=[(pa(1)+pb(1))/2 (pa(2)+pb(2))/2 z];%��Բ���е�pf

ommi=v/r;%���ٶ�
L=2*pi*r;%Բ�ܳ�
T=L/v;%��Բ�ܵ��η�������ʱ��

if (pf(1)-pa(1))>0 %������Բ�е�f��ɣ�af�ĳ�ʼ��λ��
    ommi_af=atan((pf(2)-pa(2))/(pf(1)-pa(1)));
else
    ommi_af=atan((pf(2)-pa(2))/(pf(1)-pa(1)))+pi;
end;

if (pf(1)-pb(1))>0 %����Բ�е�f��ɣ�bf�ĳ�ʼ��λ��
    ommi_bf=atan((pf(2)-pb(2))/(pf(1)-pb(1)));
else
    ommi_bf=atan((pf(2)-pb(2))/(pf(1)-pb(1)))+pi;
end;

if mod(t,2*T)<=T
    pt_x=pa(1)+r*cos(ommi_af+ommi*mod(t,T));
    pt_y=pa(2)+r*sin(ommi_af+ommi*mod(t,T));
elseif mod(t,2*T)>T
    pt_x=pb(1)+r*cos(ommi_bf-ommi*mod(t,T));
    pt_y=pb(2)+r*sin(ommi_bf-ommi*mod(t,T));
end;
pt_z=z;
pt=[pt_x pt_y pt_z];

