%   感谢亲亲使用此代码，此代码解决您的问题了吗~(@^_^@)~
%   没解决的话告诉亲亲一个好消息，登录淘宝店铺“大成软件工作室”，可以下载(????)1分钱成品代码(′▽`〃)哦~
%   是的，亲亲真的没有看错，挠破头皮的问题真的1分钱就可以解决了(づ??????)づ
%   小的这就把传送门给您，记得要收藏好哦(づ￣3￣)づ╭?～
%   传送门：https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   如果传送门失效，亲亲可以来店铺讨要，客服MM等亲亲来骚扰哦~(*/ω╲*)
function  draw_track(track_data_output , number_of_track)
%函数功能：航迹显示
%在极坐标下画出所有航迹
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_data_output --> 数据处理后,最终的输出，为一多行9列矩阵:1距离，2方位角,3俯仰角,4属于第几条航迹,5来0/去1,6积累时间,7是第几个点,8实点0/补点1,9属于哪个通道
% number_of_track  -->  已经形成的可靠航迹数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 输入变量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(number_of_track>0)
    figure(1);
    
    %pause(0.5);
    polar(0,13000,'w.');title('航迹显示');
    hold on;
    for i=1:number_of_track
        point_of_track=find(track_data_output(:,4)==i);%找出航迹号为i的所有点的所在行
        num_of_point=size(point_of_track,1);%第i条航迹的点迹数
        point_supple=find(track_data_output(point_of_track,8)==1);%找出第i条航迹的所有补点的所在行
        num_of_supple=size(point_supple,1);%第i条航迹的补点数
         %%%%%%%%%%%%%%%%第i条航迹的所有点%%%%%%%%%%%%%%%%%%%
        range=track_data_output(point_of_track(1):point_of_track(num_of_point),1)';
        azimuth=track_data_output(point_of_track(1):point_of_track(num_of_point),2)';
        elevation=track_data_output(point_of_track(1):point_of_track(num_of_point),3)';
        range_xy=range.*abs(cos(elevation));
         %%%%%%%%%%%%%%%%第i条航迹的所有点%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%第i条航迹的所有补点%%%%%%%%%%%%%%%%%%%
        range_supple=range(track_data_output(point_supple,7));
        azimuth_supple=azimuth(track_data_output(point_supple,7));
        elevation_supple=elevation(track_data_output(point_supple,7));
        range_xy_supple=range_xy(track_data_output(point_supple,7));
         %%%%%%%%%%%%%%%%第i条航迹的所有补点%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%第i条航迹的所有实点%%%%%%%%%%%%%%%%%%%
        range(track_data_output(point_supple,7))=[];
        azimuth(track_data_output(point_supple,7))=[];
        elevation(track_data_output(point_supple,7))=[];
        range_xy(track_data_output(point_supple,7))=[];
         %%%%%%%%%%%%%%%%第i条航迹的所有实点%%%%%%%%%%%%%%%%%%%
        switch i
            case 1
                polar(azimuth,range_xy,'k.');%legend('航迹1','NorthEastOutside');
                hold on;polar(azimuth_supple,range_xy_supple,'mp');
            case 2
                hold on;polar(azimuth,range_xy,'ro');
                hold on;polar(azimuth_supple,range_xy_supple,'bh');
            case 3
                hold on;polar(azimuth,range_xy,'yx');
                hold on;polar(azimuth_supple,range_xy_supple,'k>');
            case 4
                hold on;polar(azimuth,range_xy,'g+');
                hold on;polar(azimuth_supple,range_xy_supple,'rd');
            case 5
                hold on;polar(azimuth,range_xy,'b*');
                hold on;polar(azimuth_supple,range_xy_supple,'ys');
            case 6
                hold on;polar(azimuth,range_xy,'cd');
                hold on;polar(azimuth_supple,range_xy_supple,'m*');
            case 7
                hold on;polar(azimuth,range_xy,'ms');
                hold on;polar(azimuth_supple,range_xy_supple,'k+');
            case 8
                hold on;polar(azimuth,range_xy,'b<');
                hold on;polar(azimuth_supple,range_xy_supple,'cx');
            case 9
                hold on;polar(azimuth,range_xy,'kp');
                hold on;polar(azimuth_supple,range_xy_supple,'g.');
            case 10
                hold on;polar(azimuth,range_xy,'gh');
                hold on;polar(azimuth_supple,range_xy_supple,'bo');
        end
    end
    hold off;

end