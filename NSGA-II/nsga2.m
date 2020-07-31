%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
function resultado = nsga2(out, I, size_cuadrante, bits_lambda, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate)
    addpath('metricas');
    if ndims(I)==3
        I=rgb2gray(I);
    end
    %I=gpuArray(I);

    mkdir(out);
    fpareto=fopen(strcat(out,'pareto.csv'),'w');
    fprintf(fpareto,'ssim; contraste(c)\n');
    fparetoSE=fopen(strcat(out,'paretoSE.csv'),'w');
    fprintf(fparetoSE,'lambda; Elemento Estructurante\n');

    fparetoXiter=fopen(strcat(out,'pareto-x-iter.csv'),'w');
    fprintf(fparetoXiter,'Generacion; ssim; contraste(c)\n');
    fparetoXiterSE=fopen(strcat(out,'pareto-x-iter_SE.csv'),'w');
    fprintf(fparetoXiterSE,'Generacion; lambda; Elemento Estructurante\n');
    
    %clc;
    %clear;
    %close all;

    %% Problem Definition

    CostFunction=@(S,L)funcion_objetivo_nsga_ii(I,S,L,size_cuadrante);      % Cost Function

    nVar=(size_cuadrante*size_cuadrante-1);             % Number of Decision Variables
    nVarLambda=bits_lambda;                             % Number of Decision Variables para lambda
    
    VarSize=[1 nVar];   % Size of Decision Variables Matrix
    VarSizeLambda=[1 nVarLambda];   % Size of Decision Variables Matrix para lambda

    VarMin=0;          % Lower Bound of Variables
    VarMax=1;          % Upper Bound of Variables

    % Number of Objective Functions
    % nObj=numel(CostFunction(randi([VarMin,VarMax],VarSize)));


    %% NSGA-II Parameters

    MaxIt=pGenerations;      % Maximum Number of Iterations

    nPop=pPopulationSize;        % Population Size

    pCrossover=pCrossoverFraction;                         % Crossover Percentage
    nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

    pMutation=0.4;                          % Mutation Percentage --NO SE ENCUENTRA EN EL DE RAINER
    nMutation=round(pMutation*nPop);        % Number of Mutants

    mu=pMutationRate;                    % Mutation Rate

    %sigma no tiene sentido para binario. No se usa la variable sigma aquí
    sigma=0.1*(VarMax-VarMin);  % Mutation Step Size


    %% Initialization

    tt=tic();

    empty_individual.Position=[];
    empty_individual.Lambda=[];
    empty_individual.Cost=[];
    empty_individual.Rank=[];
    empty_individual.DominationSet=[];
    empty_individual.DominatedCount=[];
    empty_individual.CrowdingDistance=[];

    pop=repmat(empty_individual,nPop,1);

    for i=1:nPop

        pop(i).Position=randi([VarMin,VarMax],VarSize);
        pop(i).Lambda=randi([VarMin,VarMax],VarSizeLambda);

        pop(i).Cost=CostFunction(pop(i).Position, pop(i).Lambda);

    end

    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop, F]=SortPopulation(pop);

    %% NSGA-II Main Loop

    for it=1:MaxIt

        % Crossover
        popc=repmat(empty_individual,nCrossover/2,2);
        for k=1:nCrossover/2

            i1=randi([1 nPop]);
            p1=pop(i1);

            i2=randi([1 nPop]);
            p2=pop(i2);

            [popc(k,1).Position, popc(k,2).Position]=Crossover(VarMin,VarMax,p1.Position,p2.Position);
            [popc(k,1).Lambda, popc(k,2).Lambda]=Crossover(VarMin,VarMax,p1.Lambda,p2.Lambda);

            popc(k,1).Cost=CostFunction(popc(k,1).Position,popc(k,1).Lambda);
            popc(k,2).Cost=CostFunction(popc(k,2).Position,popc(k,2).Lambda);

        end
        popc=popc(:);

        % Mutation
        popm=repmat(empty_individual,nMutation,1);
        for k=1:nMutation

            i=randi([1 nPop]);
            p=pop(i);

            popm(k).Position=Mutate(p.Position,mu,sigma);
            popm(k).Lambda=Mutate(p.Lambda,mu,sigma);

            popm(k).Cost=CostFunction(popm(k).Position,popm(k).Lambda);

        end

        % Merge
        pop=[pop
             popc
             popm]; %#ok

        % Non-Dominated Sorting
        [pop, F]=NonDominatedSorting(pop);

        % Calculate Crowding Distance
        pop=CalcCrowdingDistance(pop,F);

        % Sort Population
        pop=SortPopulation(pop);

        % Truncate
        pop=pop(1:nPop);

        % Non-Dominated Sorting
        [pop, F]=NonDominatedSorting(pop);

        % Calculate Crowding Distance
        pop=CalcCrowdingDistance(pop,F);

        % Sort Population
        [pop, F]=SortPopulation(pop);

        % Store F1
        F1=pop(F{1});

        % Show Iteration Information
        disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);

        itmat=zeros(1,numel(F1));%Se crea un matriz de 1x[cant-indiv-pareto]
        itmat(:)=it;%se agrega el nro de iteracion para el log.
        fprintf(fparetoXiter,'%g ;%g ;%g\n', [itmat; F1.Cost]);
        fprintf(fparetoXiterSE,'%g ;%g ;%g\n', [itmat; F1.Lambda; F1.Cost]);

        % Plot F1 Costs
        %figure(1);
        %PlotCosts(F1, ra);
        %pause(0.01);
            
    end
    
    final=toc(tt);
    
    fprintf(fpareto,'%g ;%g\n', [F1.Cost]);
    fprintf(fparetoSE,'%g ;%g\n', mat2str(F1.Position));
    
    fclose(fpareto);
    fclose(fparetoSE);
    fclose(fparetoXiter);
    fclose(fparetoXiterSE);

    %Archivar SE y Resultado T
    for i = 1 : length(F1)
        bestx=F1(i).Position;
        bestl=F1(i).Lambda;
        
        SR=convertir_individuo2se(bestx,size_cuadrante);
        if isempty(bestl)
            R=metodologia_morfologica_lambda(I, strel('arbitrary',SR), bi2de(bestl)+1);
        else
            R=metodologia_morfologica(I, strel('arbitrary',SR));
        end
        imwrite(SR,strcat(strcat(out, int2str(i)), '_se.png'));
        imwrite(gather(R),strcat(strcat(out, int2str(i)), '_t.png'));
    end
    
    if isa(I,'gpuArray') 
        clear I;
    end
    %% Results
    resultado={};
    resultado.tiempo=final;
    resultado.FS1=F1;
end