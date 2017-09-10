function [state, options,optchanged] = log_in_file(options,state,flag,fid,fbest,tini,I,dimension)
%LOG_IN_FILE Summary of this function goes here
%   Detailed explanation goes her
persistent h1 history r;
optchanged=false;

switch flag
 case 'init'
        fprintf(fid,'Generacion; best; promedio; cuartil3; max; min; quartil1\n');
    case {'iter','interrupt'}
        
        if rem(state.Generation,10) == 0
            ss = size(history,3);
            history(:,:,ss+1) = state.Population;
            assignin('base','gapopulationhistory',history);
        end
        
        score=1-state.Score;
        q=quantile(score,3);
        fprintf(fid,'%f; %f; %f; %f; %f; %f; %f\n',state.Generation,state.Best(state.Generation),q(2),q(3),max(score),min(score),q(1));
    case 'done'
        ss = size(history,3);
        history(:,:,ss+1) = state.Population;
        assignin('base','gapopulationhistory',history);
        
        ibest = state.Best(end);
        ibest = find(state.Score == ibest,1,'last');
        bestx = state.Population(ibest,:);        

        SR=convertir_individuo2se(bestx,dimension);             
        R=metodologia_morfologica(I, strel('arbitrary',SR));
        [c2]=CONTRASTE(R)/127.5;
        [similaridad]=nssim(I,R);
        if isa(R,'gpuArray') 
            clear R;
        end
        
        score=1-state.Score;
        q=quantile(score,3);
        t=toc(tini);
        fprintf(fbest,'%f; %f; %f; %f; %f; %f; %f; %f; %f\n',t,state.Best(state.Generation),q(2),q(3),max(score),min(score),q(1),c2,similaridad);
end
end
