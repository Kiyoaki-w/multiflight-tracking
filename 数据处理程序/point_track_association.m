%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function [trust_track ,point_now,track_data_output] = point_track_association(point_now ,trust_track ,track_data_output,...
    ts,K_association,time_accumulate)

% ����ʵ�ֹ��ܣ�
% �㼣�ɿ�������������
% ����������ɿ���������,�ܹ������ϵ�,���¿ɿ�����
% ����,������ʱ�㼣�ļ�,���ں�����ʼ,��������Ϊ����
% һ���㼣ֻ�ܹ���һ����������������õ�����ϵĺ������øõ������¸ú���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% point_now --> ÿ�δ�CFAR��������ĵ㼣���������������˲���ʣ��㼣���洢�ڻ�������
% trust_track --> �ɿ������ļ����洢�Ѿ��γɵĿɿ���������Ϣ
% 1-6�У�ÿ���������һ������˲���Ϣ��1���룬2�������ٶȣ�3��λ��,4��λ�����ٶȣ�5������,6�������ٶ�
% 7-42�У��˲����Э������Ϣ������һ��6*6�ľ��󣬴��������36��
% 43����ʶ���־,44��/ȥ,45�ǵڼ�����,46ʵ��/����,47�����ĸ�ͨ����48����δ�����´�����49���±�־0δ����/1���£�50��������������ֵ��
% K_association --> һ���ɹ�ѡ��Ĳ������������ڲ��Ŵ�С
% time_accumulate --> ���۵�ʱ�䣬Ҳ���ӵ�һ�����ݵ�������������֮����������ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% point_now --> ÿ�δ�CFAR��������ĵ㼣���������������˲���ʣ��㼣���洢�ڻ�������
% trust_track --> �ɿ������ļ����洢�Ѿ��γɵĿɿ���������Ϣ
% track_data_output --> ���������ݴ�����Ϻ�����ĺ�����Ϣ���洢���������Ϣ�Ķ���9�о��󣻸��д��������£�1��
% �룬2��λ��,3������,4���ڵڼ�������,5��/ȥ,6����ʱ��,7�ǵڼ�����,8ʵ��/���㣬9�����ĸ�ͨ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=[1 ts 0 0 0 0;0 1 0 0 0 0;0 0 1 ts 0 0;0 0 0 1 0 0;0 0 0 0 1 ts;0 0 0 0 0 1];%״̬����
I=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1];%��λ����
G=[ts^2/2 0 0;ts 0 0;0 ts^2/2 0;0 ts 0;0 0 ts^2/2;0 0 ts];%���������ֲ�����
H=[1 0 0 0 0 0 ;0 0 1 0 0 0;0 0 0 0 1 0];%�۲����
% sigma_r=60;
% sigma_a=1/180*pi;
% sigma_e=1/180*pi;
sigma_r=10;%Ŀ�����Ĺ۲�������׼��
sigma_a=1e-1;%Ŀ�귽λ�ǵĹ۲�������׼��
sigma_e=1e-1;%Ŀ�긩���ǵĹ۲�������׼��

sigma_ar=3;%Ŀ�����Ĺ���������׼��
sigma_aa=3;%Ŀ�귽λ�ǵĹ���������׼��
sigma_ae=3;%Ŀ�긩���ǵĹ���������׼��
Q=[sigma_ar^2 0 0;0 sigma_aa^2 0;0 0 sigma_ae^2];%��������Э�������G*Q*G'
R_noise=[sigma_r^2 0 0;0 sigma_a^2 0;0 0 sigma_e^2];%�۲�����Э����
for loop_of_trust_track = 1:size(trust_track ,1)
    for loop_of_point = 1:size(point_now ,1)
        if(point_now(loop_of_point ,8) == 0 & trust_track(loop_of_trust_track ,49) == 0)   % ȷ��һ���㼣ֻ����һ������
            state_filter_last= trust_track(loop_of_trust_track,1:6)';%���������һ�������Ϣ
            state_filter_predict=F*state_filter_last;%�ú����ϵ����һ����Ԥ����һ���λ��
            for i=1:6
                filter_variance_last(i,:)=trust_track(loop_of_trust_track,1+i*6:6+i*6);%%%�˲����Э����
            end
            filter_variance_predict=F*filter_variance_last*F'+G*Q*G';           %%%Ԥ�����Э����
            sigma_r_predict=filter_variance_predict(1,1);%�õ�������Ԥ������׼��
            sigma_a_predict=filter_variance_predict(3,3);%�õ���λ����Ԥ������׼��
            sigma_e_predict=filter_variance_predict(5,5);%�õ���������Ԥ������׼��
            range_gate_of_association = K_association*sqrt(sigma_r^2+sigma_r_predict^2+ts^4/4*sigma_ar^2);% �㼣���������еľ�������
            azimuth_gate_of_association = K_association*sqrt(sigma_a^2+sigma_a_predict^2+ts^4/4*sigma_aa^2);%�㼣���������еķ�λ������
            elevation_gate_of_association = K_association*sqrt(sigma_e^2+sigma_e_predict^2+ts^4/4*sigma_ae^2);%�㼣���������еĸ���������
            if (abs(state_filter_predict(1,1) - point_now(loop_of_point ,1))<= range_gate_of_association & ...
                    abs(state_filter_predict(3,1) - point_now(loop_of_point ,2))<= azimuth_gate_of_association &...
                    abs(state_filter_predict(5,1) - point_now(loop_of_point ,3))<= elevation_gate_of_association)
                point_now(loop_of_point ,8) = 1;%��سɹ������������ϵĵ�����˲�
                state_view=point_now(loop_of_point ,1:3)';%�õ��۲�ֵ
                %%%%%%%%%%%%%%%%�˲�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

                Kalman_gain=filter_variance_predict*H'*[H*filter_variance_predict*H'+R_noise]^(-1);          %%%%����

                filter_variance=[I-Kalman_gain*H]*filter_variance_predict;         %%%%�˲����Э����

                state_filter=state_filter_predict+Kalman_gain*[state_view-H*state_filter_predict];     %%%%�˲�����
                %%%%%%%%%%%%%%%%%�˲�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                trust_track(loop_of_trust_track ,1:6) = state_filter';   %  ���һ�����״̬����
                for i=1:6
                    trust_track(loop_of_trust_track,1+i*6:6+i*6)=filter_variance(i,:);
                end
                 
                trust_track(loop_of_trust_track ,45) =  trust_track(loop_of_trust_track ,45) + 1;    % �ɿ�����������һ
                trust_track(loop_of_trust_track ,46) = 0;      %  ʵ/�����־��ʵ��Ϊ0������Ϊ1
                trust_track(loop_of_trust_track ,48) = 0;      %  δ��ʵ����´�����0;
                trust_track(loop_of_trust_track ,49) = 1;     %  ���±�־��1
                trust_track (loop_of_trust_track ,50) = point_now(loop_of_point ,7) ;     % ���º������������޴���
                if(trust_track(loop_of_trust_track ,45) > 2 )     %   ������Ǹ���ʼ�ĺ���,���
                    track_data_output = [track_data_output;state_filter(1,1) ,state_filter(3,1),state_filter(5,1),...           
                                   trust_track(loop_of_trust_track ,43),trust_track(loop_of_trust_track ,44),...
                                   time_accumulate,trust_track(loop_of_trust_track ,45),trust_track(loop_of_trust_track ,46),trust_track(loop_of_trust_track ,47)];
                end 
            end
        end
    end
     
end
point_now(find(point_now(:,8) == 1) ,:) = [];  % ɾ�����ɿ����������ϵĵ㼣
track_data_output = sortrows(track_data_output,4);     % ���պ����������