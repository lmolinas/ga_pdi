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
function nsga2(I, ra, size_cuadrante, pPopulationSize, pGenerations, pCrossoverFraction, pMutationRate)
    addpath('metricas');
    if ndims(I)==3
        I=rgb2gray(I);
    end
    %I=gpuArray(I);

    %clc;
    %clear;
    %close all;

    %% Problem Definition

    CostFunction=@(S)funcion_objetivo_nsga_ii(I,S,size_cuadrante,CONTRASTE(I)/127.5);      % Cost Function

    nVar=size_cuadrante*size_cuadrante-1;             % Number of Decision Variables

    VarSize=[1 nVar];   % Size of Decision Variables Matrix

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

    sigma=0.1*(VarMax-VarMin);  % Mutation Step Size


    %% Initialization

    empty_individual.Position=[];
    empty_individual.Cost=[];
    empty_individual.Rank=[];
    empty_individual.DominationSet=[];
    empty_individual.DominatedCount=[];
    empty_individual.CrowdingDistance=[];

    pop=repmat(empty_individual,nPop,1);

    for i=1:nPop

        pop(i).Position=randi([VarMin,VarMax],VarSize);

        pop(i).Cost=CostFunction(pop(i).Position);

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

            popc(k,1).Cost=CostFunction(popc(k,1).Position);
            popc(k,2).Cost=CostFunction(popc(k,2).Position);

        end
        popc=popc(:);

        % Mutation
        popm=repmat(empty_individual,nMutation,1);
        for k=1:nMutation

            i=randi([1 nPop]);
            p=pop(i);

            popm(k).Position=Mutate(p.Position,mu,sigma);

            popm(k).Cost=CostFunction(popm(k).Position);

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

        % Plot F1 Costs
        figure(1);
        PlotCosts(F1, ra);
        pause(0.01);

    end

    %% Results
end