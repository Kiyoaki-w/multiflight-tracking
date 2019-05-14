%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function  draw_track(track_data_output , number_of_track)
%�������ܣ�������ʾ
%�ڼ������»������к���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_data_output --> ���ݴ����,���յ������Ϊһ����9�о���:1���룬2��λ��,3������,4���ڵڼ�������,5��0/ȥ1,6����ʱ��,7�ǵڼ�����,8ʵ��0/����1,9�����ĸ�ͨ��
% number_of_track  -->  �Ѿ��γɵĿɿ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(number_of_track>0)
    figure(1);
    
    %pause(0.5);
    polar(0,13000,'w.');title('������ʾ');
    hold on;
    for i=1:number_of_track
        point_of_track=find(track_data_output(:,4)==i);%�ҳ�������Ϊi�����е��������
        num_of_point=size(point_of_track,1);%��i�������ĵ㼣��
        point_supple=find(track_data_output(point_of_track,8)==1);%�ҳ���i�����������в����������
        num_of_supple=size(point_supple,1);%��i�������Ĳ�����
         %%%%%%%%%%%%%%%%��i�����������е�%%%%%%%%%%%%%%%%%%%
        range=track_data_output(point_of_track(1):point_of_track(num_of_point),1)';
        azimuth=track_data_output(point_of_track(1):point_of_track(num_of_point),2)';
        elevation=track_data_output(point_of_track(1):point_of_track(num_of_point),3)';
        range_xy=range.*abs(cos(elevation));
         %%%%%%%%%%%%%%%%��i�����������е�%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%��i�����������в���%%%%%%%%%%%%%%%%%%%
        range_supple=range(track_data_output(point_supple,7));
        azimuth_supple=azimuth(track_data_output(point_supple,7));
        elevation_supple=elevation(track_data_output(point_supple,7));
        range_xy_supple=range_xy(track_data_output(point_supple,7));
         %%%%%%%%%%%%%%%%��i�����������в���%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%��i������������ʵ��%%%%%%%%%%%%%%%%%%%
        range(track_data_output(point_supple,7))=[];
        azimuth(track_data_output(point_supple,7))=[];
        elevation(track_data_output(point_supple,7))=[];
        range_xy(track_data_output(point_supple,7))=[];
         %%%%%%%%%%%%%%%%��i������������ʵ��%%%%%%%%%%%%%%%%%%%
        switch i
            case 1
                polar(azimuth,range_xy,'k.');%legend('����1','NorthEastOutside');
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