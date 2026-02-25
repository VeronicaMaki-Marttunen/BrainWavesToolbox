function BWT_runSVD(folderpath,outputpath,nSess,subjects,tasks)

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
                disp('Work in progress...')

                temp=ft_read_cifti(inputfile);
                epi=temp.dtseries;
                [gls_neg_pk,locs] = findpeaks(-double(nanmean(epi)));
                idx_dly = zeros(size(epi,1),size(locs,2)-1);
                for li = 1:size(locs,2)-1
                    clear tmp_prin
                    tmp_prin = epi(:,locs(li):locs(li+1));
                    % locate max peaks in each bin/electrode
                    for lj = 1:size(epi,1)
                        tmp2_prin = tmp_prin(lj,:);
                        [pks_prin, a_prin] = findpeaks(double(tmp2_prin));
                        thre1 = 0;
                        % find location of largest peak in each bin/electrode
                        if isempty(a_prin)
                            idx_dly(lj,li) = nan;
                        elseif size(a_prin,2)>1
                            [valmax1,id_prin] = max(pks_prin);
                            %             if valmax1<=thre1
                            %                 idx_dly(lj,li) = nan;
                            %             else
                            idx_dly(lj,li) = a_prin(id_prin);
                            %             end
                        elseif size(a_prin,2)==1
                            idx_dly(lj,li) = a_prin;
                        else
                            idx_dly(lj,li) = nan;
                        end
                    end
                end
                idx_dly2 = [idx_dly2, idx_dly];
                % Save PD
            else
                disp([inputfile,' does not exist'])
            end
        end
    end
end
seg_all = idx_dly2;
seg_all2 = [];
cont = 1;
for li = 1:size(seg_all,2)
    temp1 = seg_all(:,li);
    if sum(isnan(temp1))<size(seg_all,1)*0.2
        seg_all2 = cat(2,seg_all2,inpaint_nans(temp1,5));
    else
        li_nan(cont) = li;
        cont = cont+1;
    end
end
delay_test3 = seg_all2 - repmat(mean(seg_all2),size(seg_all,1),1);
if size(delay_test3,1)==0
    disp('No data was found.')
else
[U,S,V] = svd(delay_test3,"econ");

temp2 = diag(S);
var_explained = temp2.^2/sum(temp2.^2);

save([outputpath,'\SVD_ALLSUBJ.mat'],'U','V','S','var_explained')

for eg = 1:5
pd= U(:,eg);
cifti = ft_read_cifti(inputfile);
cifti.time=cifti.time(1);
cifti.hdr.dim(6)=1;
cifti.dtseries=pd;

ft_write_cifti(['EV',num2str(eg),'.nii'],cifti,'parameter','dtseries');
end

disp('Work successfully completed.')

end

