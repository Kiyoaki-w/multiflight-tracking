%   ��л����ʹ�ô˴��룬�˴�����������������~(@^_^@)~
%   û����Ļ���������һ������Ϣ����¼�Ա����̡������������ҡ�����������(????)1��Ǯ��Ʒ����(�䨌`��)Ŷ~
%   �ǵģ��������û�п�������ͷƤ���������1��Ǯ�Ϳ��Խ����(��??????)��
%   С����ͰѴ����Ÿ������ǵ�Ҫ�ղغ�Ŷ(�ţ�3��)�Ũq?��
%   �����ţ�https://item.taobao.com/item.htm?spm=a1z10.1-c.w4004-15151018122.5.uwGoq5&id=538759553146
%   ���������ʧЧ�����׿�����������Ҫ���ͷ�MM��������ɧ��Ŷ~(*/�بv*)
function [temp_point ,trust_track ,track_data_output ,number_of_track] = track_start(temp_point ,point_now ,trust_track ,...
    K_start ,time_accumulate ,ts ,sigma_r,sigma_a,sigma_e ,track_data_output ,number_of_track) 
% ����ʵ�ֹ��ܣ�
% ���û�������������һ��Ҫ��������������һ������
% ���һ�����ʱ�㼣�еĵ�������ˣ����������ٸ������ĵ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temp_point --> ��ʱ�㼣�ļ����洢������ʼ�͵㼣��������ʱû���õ��ĵ㼣
% point_now --> ÿ�δ�CFAR��������ĵ㼣���������������˲���ʣ��㼣���洢�ڻ�������
% trust_track --> �ɿ������ļ����洢�Ѿ��γɵĿɿ���������Ϣ
% K_start --> �ɵ����������ڵ���������ʼ���ŵĴ�С
% time_accumulate --> ���۵�ʱ�䣬Ҳ���ӵ�һ�����ݵ�������������֮����������ʱ��
% ts --> ÿ��������֮��ļ��ʱ��
% sigma_r --> ����۲�������׼��
% sigma_a --> ��λ�ǹ۲�������׼��
% sigma_e --> �����ǹ۲�������׼��
% track_data_output --> ���������ݴ�����Ϻ�����ĺ�����Ϣ
% number_of_track --> �Ѿ��γɵĺ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temp_point --> ��ʱ�㼣�ļ����洢������ʼ�͵㼣��������ʱû���õ��ĵ㼣,����8�о���1�����룻2����λ�ǣ�3�������ǣ�4��ͨ���ţ�5������ʱ�䣻
% 6���㼣δ�ô�����7��ɾ�����ޣ�8������/δ��
% trust_track --> �ɿ������ļ����洢�Ѿ��γɵĿɿ���������Ϣ���洢�ɿ�������Ϣ�Ķ���50�о�����������ÿ���ɿ����������
% һ�������Ϣ����������ֱ��ǣ�
% 1-6�У�ÿ���������һ������˲���Ϣ��1���룬2�������ٶȣ�3��λ��,4��λ�����ٶȣ�5������,6�������ٶ�
% 7-42�У��˲����Э������Ϣ������һ��6*6�ľ��󣬴��������36��
% 43����ʶ���־,44��/ȥ,45�ǵڼ�����,46ʵ��/����,47�����ĸ�ͨ����48����δ�����´�����49���±�־0δ����/1���£�50��������������ֵ��
% track_data_output --> ���������ݴ�����Ϻ�����ĺ�����Ϣ���洢���������Ϣ�Ķ���9�о��󣻸��д��������£�1��
% �룬2��λ��,3������,4���ڵڼ�������,5��/ȥ,6����ʱ��,7�ǵڼ�����,8ʵ��/���㣬9�����ĸ�ͨ����

% number_of_track --> �Ѿ��γɵĺ�����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
number_of_point = 1 ; %   �Ǹú����еĵ�һ��
flag_of_come_go = 0;  %   0��/1ȥ��־
flag_of_ture_void = 0;%   0ʵ��/1����־`
flat_of_renew = 0;    %   �������±�־ 0δ����/1����
number_of_unrenew = 0;%   ����δ�����´���
for  loop_of_now = 1:size(point_now ,1)
    for loop_of_pre = 1:size(temp_point ,1)
        if(temp_point(loop_of_pre,8) == 0 & point_now(loop_of_now,8) == 0) % ����õ�û����ѯ
%             range_gate_of_start=0.5*K_start*sqrt(sigma_r^2*ts^2+2*sigma_r^2);
%             azimuth_gate_of_start=0.5*K_start*sqrt(sigma_a^2*ts^2+2*sigma_a^2);
%             elevation_gate_of_start=0.5*K_start*sqrt(sigma_e^2*ts^2+2*sigma_e^2);
            range_gate_of_start=100;%������ʼ�в��Ŵ�С
            azimuth_gate_of_start=0.1;%������ʼ�в��Ŵ�С
            elevation_gate_of_start=0.1;%������ʼ�в��Ŵ�С
            %������ʼ����2/2�߼���������������γɿɿ�����
            if(abs(point_now(loop_of_now,1) - temp_point(loop_of_pre,1)) <= range_gate_of_start & ...   % ��ʱ�㼣�еĵ������ĵ���������
                    abs(point_now(loop_of_now ,2) - temp_point(loop_of_pre,2)) <= azimuth_gate_of_start & ... 
                    abs(point_now(loop_of_now ,3) - temp_point(loop_of_pre,3)) <= elevation_gate_of_start )   
                temp_point(loop_of_pre,8) = 1;     % ��ʱ�㼣�иõ��ѱ�ʹ��
                point_now(loop_of_now,8) = 1;  % ������Ϣ�иõ��ѱ�ʹ��
                first_point_of_track = [temp_point(loop_of_pre,1);temp_point(loop_of_pre,2);temp_point(loop_of_pre,3)];  % �洢�ú����ĵ�һ��
                second_point_of_track = [point_now(loop_of_now,1);point_now(loop_of_now,2);point_now(loop_of_now,3)];   % �洢�ú����ĵڶ���
                [state_initial,variance_initial] = kalman_filter_initial(first_point_of_track ,second_point_of_track ,ts ,...
                                                                      sigma_r,sigma_a,sigma_e);  % ���ÿ������˲�����ʼ������
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������Ŀ���˶���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                if (point_now(loop_of_now,1) - temp_point(loop_of_pre,1) > 0)  % ��һ�д������ �жϷ��������ȥ����
                    flag_of_come_go = 1;
                elseif (point_now(loop_of_now,1) - temp_point(loop_of_pre,1) < 0)
                    flag_of_come_go = 0;
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��������Ŀ���˶���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                number_of_track = number_of_track + 1;   % �γɵĿɿ���������1    
                if (isempty (trust_track) == 1)            % ����ɿ�����Ϊ�գ�trust_track�ͷǿ�ʱ������
                    track_data_output = [track_data_output;temp_point(loop_of_pre,1) ,temp_point(loop_of_pre,2) ,temp_point(loop_of_pre,3) ,...
                            number_of_track ,flag_of_come_go ,temp_point(loop_of_pre,5),number_of_point ,...
                            flag_of_ture_void ,point_now(loop_of_now,4)];         %  ����ú����ĵ�һ����
                    track_data_output = [track_data_output;point_now(loop_of_now,1) ,point_now(loop_of_now ,2) ,point_now(loop_of_now,3) ,...
                            number_of_track ,flag_of_come_go ,point_now(loop_of_now ,5) ,number_of_point + 1 ,...
                            flag_of_ture_void ,point_now(loop_of_now,4)];        %  ����ú����ĵڶ���
                    trust_track(1,1:6) = state_initial';   
                    for i=1:6
                        trust_track(1,1+i*6:6+i*6)=variance_initial(i,:);
                    end

                    trust_track(1,43) = number_of_track;
                    trust_track(1,44) = flag_of_come_go;
                    trust_track(1,45) = number_of_point + 1;
                    trust_track(1,46) = flag_of_ture_void;
                    trust_track(1,47) = point_now(loop_of_now ,4);
                    trust_track(1,48) = number_of_unrenew;
                    trust_track(1,49) = flat_of_renew;
                    trust_track(1,50) = point_now(loop_of_now ,7); % �洢�ú�������Ϣ
                                      
                elseif (isempty (trust_track) == 0)       % ����ɿ������ǿ�
                    track_data_output = [track_data_output;temp_point(loop_of_pre,1) ,temp_point(loop_of_pre,2) ,temp_point(loop_of_pre,3) ,...
                            number_of_track ,flag_of_come_go ,temp_point(loop_of_pre,5) ,number_of_point ,...
                            flag_of_ture_void ,point_now(loop_of_now ,4)];               %  ����ú����ĵ�һ����
                    track_data_output = [ track_data_output; point_now(loop_of_now ,1) ,point_now(loop_of_now ,2) ,point_now(loop_of_now,3) ,...
                            number_of_track ,flag_of_come_go ,point_now(loop_of_now ,5) ,number_of_point + 1 ,...
                            flag_of_ture_void ,point_now(loop_of_now,4)];                %  ����ú����ĵڶ���
                    
                    trust_track  = [trust_track;state_initial',variance_initial(1,:),variance_initial(2,:),variance_initial(3,:),...
                        variance_initial(4,:),variance_initial(5,:),variance_initial(6,:),number_of_track,flag_of_come_go,number_of_point + 1,...
                        flag_of_ture_void,point_now(loop_of_now ,4),number_of_unrenew,flat_of_renew,point_now(loop_of_now ,7)];  %���º�����Ϣ                    
                end 
            end
        end
    end
end
point_now(find(point_now(: ,8) == 1),:) = [];    % ɾ��������Ϣ���Ѿ�ʹ�ù��ĵ㼣���ڰ��б�־λ=0�ļ�δ�����ϵĵ㼣������ʱ�㼣�ļ���
temp_point(find(temp_point(:,8) == 1),:) = [];            % ɾ����ʱ�㼣���Ѿ�ʹ�ù��ĵ㼣
if (isempty(temp_point) == 0) % �����ʱ�㼣�л��е㼣
    temp_point(: ,6) = temp_point(: ,6) + 1;   % �㼣δʹ�ô�����һ
    temp_point(find(temp_point(: ,6) == temp_point(: ,7)),:) = [];   % ����㼣û��ʹ�ô����ﵽ����ֵ,��ɾ���õ㼣
end
temp_point = [temp_point;point_now];     %   ��������Ϣ��δ�����ϵĵ㼣������ʱ�㼣�ļ���