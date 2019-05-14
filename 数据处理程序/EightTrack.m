%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function pt=EightTrack(dist_8eye1,azimuth_8eye1,dist_8eye2,azimuth_8eye2,height,v,t)
% EightTrack():8字形航迹的实现
%输入 :控制台飞行参数,对8字形而言
%      一号圆心的距离dist_8eye1和方位azimuth_8eye1、二号圆心的距离dist_8eye2和方位azimuth_8eye2、高度height、速度v、当前时刻t
%输出：该8字形轨迹上t时刻的点的坐标pt 

Ra=sqrt(dist_8eye1^2-height^2);thi_a=azimuth_8eye1;%一号圆心投影在XOY平面上的径向距离和方位
Rb=sqrt(dist_8eye2^2-height^2);thi_b=azimuth_8eye2;%二号圆心投影在XOY平面上的径向距离和方位
z=height;%高度
r=sqrt(Ra^2+Rb^2-2*Ra*Rb*cos(thi_a-thi_b))/2;%半径
pa=[Ra.*cos(thi_a) Ra.*sin(thi_a) z];%圆心pa坐标
pb=[Rb.*cos(thi_b) Rb.*sin(thi_b) z];%圆心pb坐标
pf=[(pa(1)+pb(1))/2 (pa(2)+pb(2))/2 z];%两圆的切点pf

ommi=v/r;%角速度
L=2*pi*r;%圆周长
T=L/v;%单圆周单次飞行所需时间

if (pf(1)-pa(1))>0 %设在两圆切点f起飞，af的初始方位角
    ommi_af=atan((pf(2)-pa(2))/(pf(1)-pa(1)));
else
    ommi_af=atan((pf(2)-pa(2))/(pf(1)-pa(1)))+pi;
end;

if (pf(1)-pb(1))>0 %在两圆切点f起飞，bf的初始方位角
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

