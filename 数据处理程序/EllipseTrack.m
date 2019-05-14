%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function pt=EllipseTrack(dist_ellieye,azimuth_ellieye,len_laxis,len_saxis,height,v,t)
% EllipseTrack():椭圆航迹的实现
%输入:控制台飞行参数,对椭圆而言
%      中心的距离dist_ellieye和方位azimuth_ellieye、长轴len_laxis、短轴len_saxis、高度height、速度v、当前时刻t
%输出：该椭圆轨迹上t时刻的点的坐标pt

Rf=sqrt(dist_ellieye^2-height^2);thi_f=azimuth_ellieye;%椭圆中心pf投影在XOY平面上的径向距离和方位
z=height;%高度
pf=[Rf.*cos(thi_f) Rf.*sin(thi_f) z];%椭圆中心pf
a=len_laxis;b=len_saxis;%长轴长2a，短轴长2b

%发现光4个参数不足以定义一个椭圆——暂时采取特殊处理：长轴平行于X轴时的焦点坐标
pa=[pf(1)+sqrt(a^2-b^2) pf(2) z];%焦点pa坐标
pb=[pf(1)-sqrt(a^2-b^2) pf(2) z];%焦点pb坐标

fi=atan(b/a);%ф，对照任务书,与圆弧的界限角相关
dn=(sqrt(a^2+b^2)-(a-b))/2/cos(fi);% dn=dh/2/cos(fi)
pn=pf+(pa-pb)/(2*sqrt(a^2-b^2))*(a-dn);%近似圆弧四个圆心之一点pn
pm=pf+(pb-pa)/(2*sqrt(a^2-b^2))*(a-dn);%近似圆弧四个圆心之二点pm
r1=dn;%第一类圆弧半径
ommi_1=v/r1;
alpha=pi-2*fi;%第一类圆弧的界限方位角范围α
T1=alpha/ommi_1;%飞完第一类圆弧的时长

fs=(a-dn)*(a/b);
syms x y      %[x y 0]表示向量fs的坐标
[x,y]=solve(sum([x y 0].*(pa-pb)),x^2+y^2-fs^2) %x、y都是列向量
x1=double(x);
y1=double(y);
ps=pf+[x1(2) y1(2) 0]; %近似圆弧四个圆心之三点ps
pt=pf+[x1(1) y1(1) 0]; %近似圆弧四个圆心之四点pt
r2=fs+b;%第二类圆弧半径
ommi_2=v/r2;
beta=2*fi;%第二类圆弧的界限方位角范围β
T2=beta/ommi_2;%飞完第二类圆弧的时长

if (pn(1)-pt(1))>0
    ommi_tn=atan((pn(2)-pt(2))/(pn(1)-pt(1)));%tn的斜率就是圆弧分界处的方位角
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

