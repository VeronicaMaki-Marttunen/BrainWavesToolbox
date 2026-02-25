function BWT_runBW(folderpath,PDpath,outputpath,nSess,subjects,tasks,num_bins,imout,tr_data) 
% %% calculate time-position graph, time-position correlation, and speed of propagation along a specific brain map
% clear all;
% clc;
Subjects=subjects;

Nsub=length(Subjects);
nsess=nSess;
ntasks=length(tasks);
idx_dly2 = [];

cd(folderpath)
for subject = 1:Nsub
    disp(subject)
    for sess=1:nsess
        for task1 = 1:ntasks
            inputfile = ['sub-',num2str(Subjects(subject)),'_ses-',num2str(sess),'_task-',tasks{task1},'_run-1_space-fsLR_den-91k_bold.dtseries.nii'];
            oi=ls (inputfile);
            if length(oi)>1
                disp('Running...')
                %% load data
                %system('wb_command -cifti-smoothing input_data.dtseries.nii 2 2 COLUMN input_data_smoothed.dtseries.nii -left-surface /path/to/surf_structure/S900.L.inflated_MSMAll.32k_fs_LR.surf.gii -right-surface /path/to/surf_structure/S900.R.inflated_MSMAll.32k_fs_LR.surf.gii'); % spatially smoothing input data
                cii_3 = ft_read_cifti(inputfile);
                dtser = cii_3.dtseries(1:32492*2,:);
                nandtser = isnan(dtser(:,1));
                dtser(nandtser,:) = [];
                epi1msk = FT_Filter_mulch3(dtser',[0.001 .05],'bandpass',1/tr_data)'; % temporally smoothing data
                epi1msk = zscore(epi1msk')';
                gs_LR1 = mean(epi1msk); % calculate the global mean of input data


                % based on average pd
                temp=ft_read_cifti(PDpath);
                pg1 = temp.dtseries(1:32492*2,:);
                pg1(nandtser)=[];

                pgd1 = discretize(pg1,prctile(pg1,0:100/num_bins:100));
                pgd1 = pgd1-min(pgd1)+1;
                tw1 = grpstats(epi1msk,pgd1); % tw1: time-position graph along the brain map

%                 % Save map bin assignment
%                 cifti = ft_read_cifti(inputfile);
%                 cifti.time=cifti.time(1);
%                 cifti.hdr.dim(6)=1;
%                 dtser = cii_3.dtseries;
%                 dtser=dtser(:,1);
%                 dtser(32492*2+1:end)=NaN;
%                 dtser(~isnan(dtser))=pgd1;
%                 cifti.dtseries=dtser;
%                 ft_write_cifti('bin_assignment.nii',cifti,'parameter','dtseries');


                %% find delay of local peaks relative to global peak at each position: idx_tem_prin
                [gls_neg_pk,locs] = findpeaks(-double(gs_LR1));
                locs = [1 locs length(gs_LR1)];
                idx_tem_prin = zeros(size(tw1,1),size(locs,1)-1);


                for li = 1:length(locs)-1

                    clear tmp_prin
                    tmp_prin = tw1(:,locs(li):locs(li+1));
                    if size(tmp_prin,2)>2
                        for lj = 1:size(tw1,1)

                            tmp2_prin = tmp_prin(lj,:);


                            [pks_prin, a_prin] = findpeaks(double(tmp2_prin));

                            % thre1 = 0;
                            if isempty(a_prin)
                                idx_tem_prin(lj,li) = nan;
                            elseif size(a_prin,2)>1
                                [valmax1,id_prin] = max(pks_prin);
                                %         if valmax1<=thre1
                                %         idx_tem_prin(lj,li) = nan;
                                %         else
                                idx_tem_prin(lj,li) = a_prin(id_prin);
                                %        end
                                %     elseif pks_prin>thre1
                                %         idx_tem_prin(lj,li) = a_prin;
                            elseif size(a_prin,2)==1
                                idx_tem_prin(lj,li) = a_prin;
                            else
                                idx_tem_prin(lj,li) = nan;
                            end

                        end
                    else
                    end
                end



                %% calculate time-position correlation at each segment: rval_prin_2
                sz = diff(locs);
                rval_prin_2 = zeros(1,length(locs)-1);

                for ln = 1:size(idx_tem_prin,2)%length(locs)-1
                    clear x_ax
                    x_ax = (0:(sz(ln)-1)/size(idx_tem_prin,1):(sz(ln)-1));
                    x_ax = x_ax(1:end-1);
                    % disp(ln)
                    % disp(idx_tem_prin(:,ln))
                    if sum(isnan(idx_tem_prin(:,ln)))>num_bins*0.2
                        rval_prin_2(ln) = nan;
                    else
                        [rval_prin_2(ln),~] = corr((x_ax)',idx_tem_prin(:,ln),'rows','pairwise');
                    end

                end


                % calcualte propagation speed
                x_ax = 1:num_bins;
                %temp=repmat(x_ax,length(locs)-1,1)';
                for l1=1:size(idx_tem_prin,2)%length(locs)-1
                    idx_tem_prin2=idx_tem_prin(:,l1);
                    idx = isnan(idx_tem_prin2);
                    coefficients = polyfit(idx_tem_prin2(~idx),x_ax(~idx)', 1);
                    %coefficients = polyfit(idx_tem_prin(~idx),temp(~idx), 1);%
                    coefs(l1)=coefficients(1);
                    geodesic_distance = 80; % geodesic distance on the cortical surface between sensorimotor and DMN is 80 mm based on Margulies, PNAS, 2016
                    %sped_seg = abs(coefficients(1))*geodesic_distance/num_bins/tr_data;
                    sped_seg(l1) = abs(coefficients(1))*geodesic_distance/num_bins/tr_data;
                end

                % plot time-bin sp plot
                if imout == 'Y'
                figure
                subplot(2,1,1)
                imagesc(tw1)
                hold on
                for i = 1:length(locs)-1
                    plot([locs(i) locs(i)],[0 num_bins],'k--')
                    text(locs(i),1,num2str(coefs(i)))
                end
%                 strtit=[num2str(subject),'_',tasks(task1),'_',num2str(sess),'_tw1'];
%                 disp(strtit)
%                 title(strtit)
                %caxis([-0.5 0.5])
                subplot(2,1,2)
                %figure
                plot(zscore(gs_LR1))
                xlim([0 length(gs_LR1)])
                end
                save([outputpath,'\sub-',num2str(Subjects(subject)),'_ses-0',num2str(sess),'_task-',tasks{task1},'.mat'],'locs','tw1','idx_tem_prin','rval_prin_2','sped_seg');
                
            else
                disp([inputfile,' does not exist'])
            end
        end
    end
    
end



disp('Work successfully completed.')

