%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function  [track_data_output ,trust_track,temp_point, time_accumulate, number_of_track] = datatreat(track_data_output,range_vect,ci,ts,trust_track, temp_point, time_accumulate, number_of_track)
% ����ʵ�ֹ��ܣ���ÿ������ĵ㼣�������ݴ�������������ʼ���㼣�����������������㡢����������ʣ��㼣ɾ���ȣ��γɿɿ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_data_output --> ���ݴ����,���յ���������������к��������е㼣��Ϣ��Ϊһ����9�о���:1���룬2��λ��,3������,4���ڵڼ�������,5��0/ȥ1,6����ʱ��,7�ǵڼ�����,8ʵ��0/����1,9�����ĸ�ͨ��
% range_vect --> �źŴ����õ��ĵ㼣��Ϣ��Ϊ����4�о���ÿһ�еĵ�һ��Ϊ����;�ڶ���Ϊ��λ��;������Ϊ������;������Ϊͨ����;
% ts --> ����ʱ����
% ci --> ������ǵڼ�������
% trust_track --> �ɿ�����������ÿ���ɿ����������һ�������Ϣ��Ϊһ����50�о���
% 1-6�У�ÿ���������һ������˲���Ϣ��1���룬2�������ٶȣ�3��λ��,4��λ�����ٶȣ�5������,6�������ٶ�
% 7-42�У��˲����Э������Ϣ������һ��6*6�ľ��󣬴��������36��
% 43����ʶ���־,44��/ȥ,45�ǵڼ�����,46ʵ��/����,47�����ĸ�ͨ����48����δ�����´�����49���±�־0δ����/1���£�50��������������ֵ��
% temp_point --> ��ʱ�㼣�ļ����洢������ʼ�͵㼣��������ʱû���õ��ĵ㼣������8�о���1�����룻2����λ�ǣ�3�������ǣ�4��ͨ���ţ�5������ʱ�䣻
% 6���㼣δ�ô�����7��ɾ�����ޣ�8������/δ��
% time_accumulate --> ���۵�ʱ�䣬Ҳ���ӵ�һ�����ݵ�������������֮����������ʱ��
% number_of_track  -->  �Ѿ��γɵĿɿ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% track_data_output -->  ���ݴ����,���յ����:1���룬2��λ��,3������,4���ڵڼ�������,5��0/ȥ1,6����ʱ��,7�ǵڼ�����,8ʵ��0/����1,9�����ĸ�ͨ��
% trust_track --> �ɿ�����������ÿ���ɿ����������һ�������Ϣ��Ϊһ����50�о���
% 1-6�У�ÿ���������һ������˲���Ϣ��1���룬2�������ٶȣ�3��λ��,4��λ�����ٶȣ�5������,6�������ٶ�
% 7-42�У��˲����Э������Ϣ������һ��6*6�ľ��󣬴��������36��
% 43����ʶ���־,44��/ȥ,45�ǵڼ�����,46ʵ��/����,47�����ĸ�ͨ����48����δ�����´�����49���±�־0δ����/1���£�50��������������ֵ��
% temp_point --> ��ʱ�㼣�ļ����洢������ʼ�͵㼣��������ʱû���õ��ĵ㼣������8�о���1�����룻2����λ�ǣ�3�������ǣ�4��ͨ���ţ�5������ʱ�䣻
% 6���㼣δ�ô�����7��ɾ�����ޣ�8������/δ��
% time_accumulate --> ���۵�ʱ�䣬Ҳ���ӵ�һ�����ݵ�������������֮����������ʱ��
% number_of_track  -->  �Ѿ��γɵĿɿ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


range_min = 300;   % ��ʵĿ����˲����� ����Ŀ��㼣�ľ��롢��λ�ǡ�������
range_max = 3600000;   % ���������ֵʱ������Ϊ��Ŀ��Ϊ�ɿ���
azimuth_min = 0;%��λ������ֵ
azimuth_max = pi;%��λ������ֵ
elevation_min = 0;%����������ֵ
elevation_max = pi;%����������ֵ

ts=1;
% sigma_r=60;%��Щֵ�Ƚ���ȡ����֪������ôȡ,�״����ݴ����138ҳ��sigma_r=0.1ct/2,c:���٣�t����������Ŀ��
% sigma_a=1/180*pi;%��λ�Ǻ͸�������һ���ģ�sigma_a=0.1B��B:���߲������
% sigma_e=1/180*pi;
sigma_r=10;%Ŀ�����Ĺ۲�������׼��
sigma_a=1e-2;%Ŀ�귽λ�ǵĹ۲�������׼��
sigma_e=1e-2;%Ŀ�긩���ǵĹ۲�������׼��
sigma_ar=3;%Ŀ�����Ĺ���������׼��
sigma_aa=3;%Ŀ�귽λ�ǵĹ���������׼��
sigma_ae=3;%Ŀ�긩���ǵĹ���������׼��

K_start=100;%���Ʋ��Ŵ�С�Ĳ���
K_association=2;%��Щֵ�Ƚ���ȡ����֪������ôȡ


if (isempty(range_vect) == 0)     % ����źŴ��������ݷǿ�
    index = find ( range_vect(:,1) >= range_max | range_vect(:,1) <= range_min | ...          % ��������Ԥ����������������˲�����,ȥ�����
        range_vect(:,2) >= azimuth_max | range_vect(:,2) <= azimuth_min | ...  
        range_vect(:,3) >= elevation_max  | range_vect(:,3) <= elevation_min);
    range_vect(index,:) = [];                                                               % ��������Ҫ�������ǳ�
    data_to_treat = range_vect;     % ��ͨ�������˲�������ݴ���洢����,����������
    if ( ci == 1 )                          % ���������ǵ�һ������
        time_accumulate = ts;           % ʱ�����
        if ( isempty ( data_to_treat ) == 1)    % �����������Ϊ��            
            temp_point = [];    % �������ݳ�ʼ��
            trust_track = [];
            track_data_output = [];
        elseif ( isempty ( data_to_treat ) == 0)   % ����������ݷǿ�
            range_inform = data_to_treat(:,1);  % ��ȡ����,��λ��,������,ͨ��������Ϣ     
            azimuth_inform = data_to_treat(:,2);
            elevation_inform = data_to_treat(:,3);
            DBF_inform = data_to_treat(:,4);
            %gate_of_point_delete = 5;  % �㼣���������޴��� %ceil((gate_of_range/ts)./data_to_treat(:,2));3-9���ڱ������и÷���������
            number_of_point = size (range_inform ,1); 
            gate_of_point_delete = repmat(5,number_of_point,1);% �㼣���������޴�����5
            number_of_unuse_point = ones(number_of_point ,1);%�㼣δ�ô���
            time_accumulate_vect = ones(number_of_point ,1)*time_accumulate;%����ʱ��
            flag_of_loop = zeros(number_of_point ,1);  % �ں�����ʼ�У����Ѿ���ѯ�ı�־��0δ��/1�Ѳ�
            temp_point = [range_inform ,azimuth_inform ,elevation_inform ,DBF_inform ,time_accumulate_vect ,number_of_unuse_point , gate_of_point_delete ,flag_of_loop];         % ��������ʱ�㼣��
            trust_track = [];
        end              
    elseif ( ci > 1)              % ����������ݲ��ǵ�һ��

        time_accumulate = time_accumulate + ts;  % ʱ�����
        if ( isempty ( data_to_treat ) == 1)     % �����������Ϊ��            
            if ( isempty (temp_point) == 0 )       % �����ʱ�㼣�ǿ�
                temp_point(:,6) = temp_point(:,6) + 1;   % �㼣δʹ�ô�����һ
                temp_point(find(temp_point(:,6) == temp_point(:,7)) ,:) = [];   % ����㼣û��ʹ�ô����ﵽ���޴���,��ɾ���õ㼣
            end 
            if(isempty(trust_track) == 0)   %  ����ɿ������ǿ�
                [trust_track,track_data_output,number_of_track] = track_die_out(trust_track ,track_data_output,number_of_track);%���ú�����������
                [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate);% ���ò������
            end
        elseif ( isempty ( data_to_treat ) == 0 )    % ����������ݷǿ�            
            range_inform = data_to_treat(:,1);     % ��ȡ����,��λ��,������,ͨ��������Ϣ
            azimuth_inform = data_to_treat(:,2);
            elevation_inform = data_to_treat(:,3);
            DBF_inform = data_to_treat(:,4);

            number_of_point = size (range_inform ,1); 
            gate_of_point_delete = repmat(5,number_of_point,1);% �㼣���������޴�����5
            number_of_unuse_point = ones(number_of_point ,1);      % ��ʱ�㼣��,�㼣δ��ʹ�õĴ���
            time_accumulate_vect = ones(number_of_point ,1)*time_accumulate;%����ʱ��
            flag_of_loop = zeros(number_of_point ,1);         % �ں�����ʼ�У����Ѿ���ѯ�ı�־��0δ��/1�Ѳ�
            point_now = [range_inform ,azimuth_inform ,elevation_inform ,DBF_inform ,time_accumulate_vect ,number_of_unuse_point ,gate_of_point_delete ,flag_of_loop];   % �����ڴ�����������  
            if (isempty ( trust_track ) == 0)  % ����ɿ������ǿ�
                [trust_track ,point_now,track_data_output] = point_track_association_change(point_now ,trust_track ,track_data_output,...
    ts,K_association,time_accumulate);                 % ���ù�������
                [trust_track,track_data_output,number_of_track] = track_die_out(trust_track ,track_data_output,number_of_track);%���ú�����������
                [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate); %���ò������                  % ���ò������
            end    
            if ( isempty (temp_point) == 1)     % �����ʱ�㼣Ϊ��
                temp_point = point_now;               
            elseif ( isempty (temp_point) == 0 )  % �����ʱ�㼣�ǿ�
                %�����ú�����ʼ����
                [temp_point ,trust_track ,track_data_output ,number_of_track] = track_start(temp_point ,point_now ,trust_track ,...
    K_start ,time_accumulate ,ts ,sigma_r,sigma_a,sigma_e ,track_data_output ,number_of_track) ;
            end
        end  
    end
elseif ( isempty(range_vect ) == 1)   % ������龯����������Ϊ��
    if (ci == 1)
        time_accumulate = 0;           % ʱ�����
        temp_point = [];
        trust_track = [];
    elseif (ci > 1)

        time_accumulate = time_accumulate + ts;
        if (isempty(temp_point) == 0)    % �����ʱ�㼣�ǿ�
            temp_point(:,6) = temp_point(:,6) + 1;   % �㼣δʹ�ô�����һ
            temp_point(find(temp_point(:,6) == temp_point(:,7)) ,:) = [];   % ����㼣û��ʹ�ô����ﵽ���޴���,��ɾ���õ㼣
        end
        
        if (isempty(trust_track) == 0)  %   ����ɿ������ǿ�
            [trust_track,track_data_output,number_of_track] = track_die_out(trust_track ,track_data_output,number_of_track);%���ú�����������
            [trust_track,track_data_output] = point_supplement(trust_track ,track_data_output,ts,time_accumulate);% ���ò������
        end
    end
end 


if (isempty(trust_track) == 0)

    trust_track(:,49) = 0; % һ�����ݴ�����������к������±�־��0��
    trust_track = sortrows(trust_track ,43);  % �����������������
    track_data_output = sortrows(track_data_output ,4);  % �����������������
end

