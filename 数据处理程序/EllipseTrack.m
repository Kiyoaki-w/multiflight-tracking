%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function pt=EllipseTrack(dist_ellieye,azimuth_ellieye,len_laxis,len_saxis,height,v,t)
% EllipseTrack():��Բ������ʵ��
%����:����̨���в���,����Բ����
%      ���ĵľ���dist_ellieye�ͷ�λazimuth_ellieye������len_laxis������len_saxis���߶�height���ٶ�v����ǰʱ��t
%���������Բ�켣��tʱ�̵ĵ������pt

Rf=sqrt(dist_ellieye^2-height^2);thi_f=azimuth_ellieye;%��Բ����pfͶӰ��XOYƽ���ϵľ������ͷ�λ
z=height;%�߶�
pf=[Rf.*cos(thi_f) Rf.*sin(thi_f) z];%��Բ����pf
a=len_laxis;b=len_saxis;%���᳤2a�����᳤2b

%���ֹ�4�����������Զ���һ����Բ������ʱ��ȡ���⴦������ƽ����X��ʱ�Ľ�������
pa=[pf(1)+sqrt(a^2-b^2) pf(2) z];%����pa����
pb=[pf(1)-sqrt(a^2-b^2) pf(2) z];%����pb����

fi=atan(b/a);%�棬����������,��Բ���Ľ��޽����
dn=(sqrt(a^2+b^2)-(a-b))/2/cos(fi);% dn=dh/2/cos(fi)
pn=pf+(pa-pb)/(2*sqrt(a^2-b^2))*(a-dn);%����Բ���ĸ�Բ��֮һ��pn
pm=pf+(pb-pa)/(2*sqrt(a^2-b^2))*(a-dn);%����Բ���ĸ�Բ��֮����pm
r1=dn;%��һ��Բ���뾶
ommi_1=v/r1;
alpha=pi-2*fi;%��һ��Բ���Ľ��޷�λ�Ƿ�Χ��
T1=alpha/ommi_1;%�����һ��Բ����ʱ��

fs=(a-dn)*(a/b);
syms x y      %[x y 0]��ʾ����fs������
[x,y]=solve(sum([x y 0].*(pa-pb)),x^2+y^2-fs^2) %x��y����������
x1=double(x);
y1=double(y);
ps=pf+[x1(2) y1(2) 0]; %����Բ���ĸ�Բ��֮����ps
pt=pf+[x1(1) y1(1) 0]; %����Բ���ĸ�Բ��֮�ĵ�pt
r2=fs+b;%�ڶ���Բ���뾶
ommi_2=v/r2;
beta=2*fi;%�ڶ���Բ���Ľ��޷�λ�Ƿ�Χ��
T2=beta/ommi_2;%����ڶ���Բ����ʱ��

if (pn(1)-pt(1))>0
    ommi_tn=atan((pn(2)-pt(2))/(pn(1)-pt(1)));%tn��б�ʾ���Բ���ֽ紦�ķ�λ��
else
    ommi_tn=atan((pn(2)-pt(2))/(pn(1)-pt(1)))+pi;
end;

if mod(t,2*(T1+T2))<=T1
    pt_x=pn(1)+r1*cos(ommi_tn+ommi_1*mod(t,2*(T1+T2)));
    pt_y=pn(2)+r1*sin(ommi_tn+ommi_1*mod(t,2*(T1+T2)));
elseif mod(t,2*(T1+T2))>T1&mod(t,2*(T1+T2))<=T1+T2
    pt_x=ps(1)+r2*cos(ommi_tn+alpha+ommi_2*(mod(t,2*(T1+T2))-T1));
    pt_y=ps(2)+r2*sin(ommi_tn+alpha+ommi_2*(mod(t,2*(T1+T2))-T1));
elseif mod(t,2*(T1+T2))>T1+T2&mod(t,2*(T1+T2))<=2*T1+T2
    pt_x=pm(1)+r1*cos(ommi_tn+alpha+beta+ommi_1*(mod(t,2*(T1+T2))-T1-T2));
    pt_y=pm(2)+r1*sin(ommi_tn+alpha+beta+ommi_1*(mod(t,2*(T1+T2))-T1-T2));  
elseif mod(t,2*(T1+T2))>2*T1+T2
    pt_x=pt(1)+r2*cos(ommi_tn+2*alpha+beta+ommi_2*(mod(t,2*(T1+T2))-2*T1-T2));
    pt_y=pt(2)+r2*sin(ommi_tn+2*alpha+beta+ommi_2*(mod(t,2*(T1+T2))-2*T1-T2));       
end;
pt_z=z; 
pt=[pt_x pt_y pt_z];

