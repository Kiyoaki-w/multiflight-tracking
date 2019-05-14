%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function [trust_track ,point_now,track_data_output] = point_track_association_change(point_now ,trust_track ,track_data_output,...
    ts,K_association,time_accumulate)

% ����ʵ�ֹ��ܣ�
% �㼣�ɿ�������������
% ����������ɿ���������,�ܹ������ϵ�,���¿ɿ�����
% ����,������ʱ�����ļ�,���ں�����ʼ,��������Ϊ����
% ��������ڹ��������������й����ϵĵ����Ϣ���д洢������������ͳ�Ƽ�������ò��ҷ��ҳ�ͳ�Ƽ����С�ĵ㼣�뺽�����õ㼣�˲�֮����¸�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% point_now --> ÿ�δ�CFAR��������ĵ㼣���������������˲���ʣ��㼣���洢�ڻ�������
% trust_track --> �ɿ������ļ����洢�Ѿ��γɵĿɿ���������Ϣ
%1-6�У�ÿ���������һ������˲���Ϣ��1���룬2�������ٶȣ�3��λ��,4��λ�����ٶȣ�5������,6�������ٶ�
%7-42�У��˲�Э������Ϣ������һ��6*6�ľ��󣬴��������36��
%43����ʶ���־,44��/ȥ,45�ǵڼ�����,46ʵ��/����,47�����ĸ�ͨ����48����δ�����´�����49���±�־0δ����/1���£�50������������
%��ֵ��
% range_gate_of_association --> �㼣���������еľ�������
% azimuth_gate_of_association --> �㼣���������еķ�λ������
% elevation_gate_of_association --> �㼣���������еĸ���������
% K_association --> һ���ɹ�ѡ��Ĳ������������ڲ��Ŵ�С
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% point_now --> ÿ�δ�CFAR��������ĵ㼣���������������˲���ʣ��㼣���洢�ڻ�������
% trust_track --> �ɿ������ļ����洢�Ѿ��γɵĿɿ���������Ϣ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
statistical_distance=[];
F=[1 ts 0 0 0 0;0 1 0 0 0 0;0 0 1 ts 0 0;0 0 0 1 0 0;0 0 0 0 1 ts;0 0 0 0 0 1];
I=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1];
G=[ts^2/2 0 0;ts 0 0;0 ts^2/2 0;0 ts 0;0 0 ts^2/2;0 0 ts];
H=[1 0 0 0 0 0 ;0 0 1 0 0 0;0 0 0 0 1 0];
% sigma_r=60;
% sigma_a=1/180*pi;
% sigma_e=1/180*pi;
sigma_r=10;
sigma_a=1e-2;
sigma_e=1e-2;

sigma_ar=3;
sigma_aa=3;
sigma_ae=3;
Q=[sigma_ar^2 0 0;0 sigma_aa^2 0;0 0 sigma_ae^2];%��������Э����
R_noise=[sigma_r^2 0 0;0 sigma_a^2 0;0 0 sigma_e^2];%�۲�����Э����
for loop_of_trust_track = 1:size(trust_track ,1)
    for loop_of_point = 1:size(point_now ,1)
        
            state_filter_last= trust_track(loop_of_trust_track,1:6)';
            state_filter_predict=F*state_filter_last;%�ú����ϵ����һ����Ԥ����һ���λ��
            for i=1:6
                filter_variance_last(i,:)=trust_track(loop_of_trust_track,1+i*6:6+i*6);
            end
            filter_variance_predict=F*filter_variance_last*F'+G*Q*G';           %%%Ԥ������
            sigma_r_predict=filter_variance_predict(1,1);
            sigma_a_predict=filter_variance_predict(3,3);
            sigma_e_predict=filter_variance_predict(5,5);
            range_gate_of_association = K_association*sqrt(sigma_r^2+sigma_r_predict^2+ts^4/4*sigma_ar^2);% �㼣���������еľ�������
            azimuth_gate_of_association = K_association*sqrt(sigma_a^2+sigma_a_predict^2+ts^4/4*sigma_aa^2);%�㼣���������еķ�λ������
            elevation_gate_of_association = K_association*sqrt(sigma_e^2+sigma_e_predict^2+ts^4/4*sigma_ae^2);%�㼣���������еĸ���������
            if (abs(state_filter_predict(1,1) - point_now(loop_of_point ,1))<= range_gate_of_association & ...
                    abs(state_filter_predict(3,1) - point_now(loop_of_point ,2))<= azimuth_gate_of_association &...
                    abs(state_filter_predict(5,1) - point_now(loop_of_point ,3))<= elevation_gate_of_association)
                %point_now(loop_of_point ,8) = 1;%��سɹ������������ϵĵ�����˲�
                S=H*filter_variance_predict*H'+R_noise;
                z=point_now(loop_of_point,1:3)';
                z_predict=[state_filter_predict(1,1),state_filter_predict(3,1),state_filter_predict(5,1)]';
                d=(z-z_predict)'*S^(-1)*(z-z_predict);%��������ϵ�������֮���ͳ�Ƽ��
                statistical_distance=[statistical_distance;loop_of_trust_track,loop_of_point,d];%��������й����ϵĵ�֮���ͳ�Ƽ����Ϊһ����3�о���1��������ţ�2�㼣����ţ�3ͳ�Ƽ��
                
%                 state_view=point_now(loop_of_point ,1:3)';
%                 %%%%%%%%%%%%%%%%�˲�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% 
%                 Kalman_gain=filter_variance_predict*H'*[H*filter_variance_predict*H'+R_noise]^(-1);          %%%%����
% 
%                 filter_variance=[I-Kalman_gain*H]*filter_variance_predict;         %%%%�˲�����
% 
%                 state_filter=state_filter_predict+Kalman_gain*[state_view-H*state_filter_predict];     %%%%�˲�����
%                 %%%%%%%%%%%%%%%%%�˲�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 trust_track(loop_of_trust_track ,1:6) = state_filter';   %  ���һ�����״̬����
%                 for i=1:6
%                     trust_track(loop_of_trust_track,1+i*6:6+i*6)=filter_variance(i,:);
%                 end
%                  
%                 trust_track(loop_of_trust_track ,45) =  trust_track(loop_of_trust_track ,45) + 1;    % �ɿ�����������һ
%                 trust_track(loop_of_trust_track ,46) = 0;      %  ʵ/�����־��ʵ��Ϊ0������Ϊ1
%                 trust_track(loop_of_trust_track ,48) = 0;      %  δ��ʵ����´�����0;
%                 trust_track(loop_of_trust_track ,49) = 1;     %  ���±�־��1
%                 trust_track (loop_of_trust_track ,50) = point_now(loop_of_point ,7) ;     % ���º������������޴���
%                 if(trust_track(loop_of_trust_track ,45) > 2 )     %   ������Ǹ���ʼ�ĺ���,���
%                     track_data_output = [track_data_output;state_filter(1,1) ,state_filter(3,1),state_filter(5,1),...           
%                                    trust_track(loop_of_trust_track ,43),trust_track(loop_of_trust_track ,44),...
%                                    time_accumulate,trust_track(loop_of_trust_track ,45),trust_track(loop_of_trust_track ,46),trust_track(loop_of_trust_track ,47)];
%                 end 
            end
        %end
    end     
end
for i=1:size(trust_track ,1)%%Ѱ��ͳ�Ƽ��������ͳ�Ƽ����С��
    if(isempty(statistical_distance) == 0)
        min_data=min(statistical_distance(:,3));
        min_x=find(statistical_distance(:,3)==min_data);
        
        
        track_num=statistical_distance(min_x(1),1);
        point_num=statistical_distance(min_x(1),2);
        point_now(point_num ,8) = 1;
        state_view=point_now(point_num ,1:3)';
        state_filter_last= trust_track(track_num,1:6)';
        state_filter_predict=F*state_filter_last;%�ú����ϵ����һ����Ԥ����һ���λ��
        for i=1:6
            filter_variance_last(i,:)=trust_track(track_num,1+i*6:6+i*6);
        end
        filter_variance_predict=F*filter_variance_last*F'+G*Q*G';           %%%Ԥ������
        %%%%%%%%%%%%%%%�˲�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

        Kalman_gain=filter_variance_predict*H'*[H*filter_variance_predict*H'+R_noise]^(-1);          %%%%����

        filter_variance=[I-Kalman_gain*H]*filter_variance_predict;         %%%%�˲�����

        state_filter=state_filter_predict+Kalman_gain*[state_view-H*state_filter_predict];     %%%%�˲�����
        %%%%%%%%%%%%%%%%%�˲�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        trust_track(track_num ,1:6) = state_filter';   %  ���һ�����״̬����
        for i=1:6
            trust_track(track_num,1+i*6:6+i*6)=filter_variance(i,:);
        end

        trust_track(track_num ,45) =  trust_track(track_num ,45) + 1;    % �ɿ�����������һ
        trust_track(track_num ,46) = 0;      %  ʵ/�����־��ʵ��Ϊ0������Ϊ1
        trust_track(track_num ,48) = 0;      %  δ��ʵ����´�����0;
        trust_track(track_num ,49) = 1;     %  ���±�־��1
        trust_track (track_num ,50) = point_now(point_num ,7) ;     % ���º������������޴���
        if(trust_track(track_num ,45) > 2 & trust_track(track_num ,49) == 1)     %   ������Ǹ���ʼ�ĺ���,���
            track_data_output = [track_data_output;state_filter(1,1) ,state_filter(3,1),state_filter(5,1),...           
                           trust_track(track_num ,43),trust_track(track_num ,44),...
                           time_accumulate,trust_track(track_num ,45),trust_track(track_num ,46),trust_track(track_num ,47)];
        end 
        statistical_distance(find(statistical_distance(:,1)==track_num),:)=[];%������������������Ϣɾ��
        statistical_distance(find(statistical_distance(:,2)==point_num),:)=[];%���õ㼣��������Ϣɾ��
    end
end
point_now(find(point_now(:,8) == 1) ,:) = [];  % ɾ�����ɿ����������ϵĵ㼣
track_data_output = sortrows(track_data_output,4);     % ���պ����������